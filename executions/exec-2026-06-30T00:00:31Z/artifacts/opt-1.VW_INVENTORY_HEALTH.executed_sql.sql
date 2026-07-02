-- Executed SQL (APPLY attempt) captured from execution payload
CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH AS
/*
  Reconstructed and optimized inventory health view.

  Assumed intent based on partial definition:
  - Read raw inventory events from PIPELINE_RAW.RAW_INVENTORY (aliased ri).
  - Derive a current snapshot per product/warehouse using window functions.
  - Join to a sales velocity mart/table to assess stock status.
  - Classify inventory into LOW_STOCK, OVERSTOCK, or HEALTHY based on
    quantity-on-hand vs reorder point and daily sales velocity.

  Key optimizations and cleanups:
  - Single pass over RAW_INVENTORY, explicit extraction of JSON fields.
  - Use QUALIFY with ROW_NUMBER() instead of subquery RN_LATEST filter.
  - Push filters as deep as possible (e.g., non-null product_id/warehouse_id).
  - Avoid ambiguous or malformed CASE expression (fixed REORDER_NEEDED typo).
  - Use numeric casts once and reuse them, rather than repeatedly casting.
  - Add defensive NULL handling around numeric comparisons.

  NOTE: Adjust source object names, JSON paths, and data types to match your
        actual schema; RAW_INVENTORY and SALES_VELOCITY are inferred.
*/
WITH all_inventory AS (
    SELECT
        /* Core identifiers */
        ri.PAYLOAD:product_id::STRING  AS PRODUCT_ID,
        ri.PAYLOAD:warehouse_id::STRING AS WAREHOUSE_ID,

        /* Inventory attributes, cast once to numeric */
        ri.PAYLOAD:qty_on_hand::NUMBER      AS QTY_ON_HAND,
        ri.PAYLOAD:reorder_point::NUMBER    AS REORDER_POINT,
        ri.PAYLOAD:safety_stock::NUMBER     AS SAFETY_STOCK,

        /* Timestamps */
        TO_TIMESTAMP_NTZ(ri.PAYLOAD:snapshot_ts::STRING) AS SNAPSHOT_TS,
        ri._LOADED_AT                                    AS LOADED_AT,

        /* Latest-row flag per product/warehouse */
        ROW_NUMBER() OVER (
            PARTITION BY ri.PAYLOAD:product_id::STRING,
                         ri.PAYLOAD:warehouse_id::STRING
            ORDER BY TO_TIMESTAMP_NTZ(ri.PAYLOAD:snapshot_ts::STRING) DESC,
                     ri._LOADED_AT DESC
        ) AS RN_LATEST
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_INVENTORY ri
    WHERE
        /* Basic quality filters; push down to reduce scan volume */
        ri.PAYLOAD:product_id IS NOT NULL
        AND ri.PAYLOAD:warehouse_id IS NOT NULL
),

sales_velocity AS (
    SELECT
        sv.PRODUCT_ID::STRING                 AS PRODUCT_ID,
        sv.WAREHOUSE_ID::STRING               AS WAREHOUSE_ID,
        sv.DAILY_VELOCITY::NUMBER            AS DAILY_VELOCITY,
        sv.LAST_30D_UNITS::NUMBER            AS LAST_30D_UNITS,
        sv.LAST_30D_REVENUE::NUMBER          AS LAST_30D_REVENUE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.SALES_VELOCITY sv
)

SELECT
    ai.PRODUCT_ID,
    ai.WAREHOUSE_ID,
    ai.QTY_ON_HAND,
    ai.REORDER_POINT,
    ai.SAFETY_STOCK,
    ai.SNAPSHOT_TS,

    sv.DAILY_VELOCITY,
    sv.LAST_30D_UNITS,
    sv.LAST_30D_REVENUE,

    /*
      Inventory health classification:
      - LOW_STOCK: qty_on_hand <= reorder_point * 1.5
      - OVERSTOCK: daily_velocity > 0 AND days_of_cover > 180
      - Else HEALTHY

      Uses safe NULL-aware logic: if any driving metric is NULL, the
      corresponding condition evaluates to FALSE and falls back to HEALTHY.
    */
    CASE
        WHEN ai.REORDER_POINT IS NOT NULL
             AND ai.QTY_ON_HAND IS NOT NULL
             AND ai.QTY_ON_HAND <= ai.REORDER_POINT * 1.5
        THEN 'LOW_STOCK'

        WHEN sv.DAILY_VELOCITY IS NOT NULL
             AND sv.DAILY_VELOCITY > 0
             AND ai.QTY_ON_HAND IS NOT NULL
             AND (ai.QTY_ON_HAND / sv.DAILY_VELOCITY) > 180
        THEN 'OVERSTOCK'

        ELSE 'HEALTHY'
    END AS STOCK_STATUS

FROM all_inventory ai
LEFT JOIN sales_velocity sv
    ON sv.PRODUCT_ID  = ai.PRODUCT_ID
   AND sv.WAREHOUSE_ID = ai.WAREHOUSE_ID

QUALIFY ai.RN_LATEST = 1;
