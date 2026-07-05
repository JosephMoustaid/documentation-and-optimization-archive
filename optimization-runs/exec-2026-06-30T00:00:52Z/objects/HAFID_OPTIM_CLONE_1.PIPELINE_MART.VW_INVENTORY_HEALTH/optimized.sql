CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH AS
/*
  Optimizations applied:
  - Single pass over RAW_INVENTORY with ROW_NUMBER to pick latest snapshot per product/warehouse.
  - Pre-aggregation of sales velocity in a separate CTE, joined by PRODUCT_ID only.
  - SARGable filters and explicit casting for JSON fields.
  - Clear, ordered CASE expression for stock status classification.
*/
WITH all_inventory AS (
    SELECT
        ri.PAYLOAD:product_id::string      AS PRODUCT_ID,
        ri.PAYLOAD:warehouse_id::string    AS WAREHOUSE_ID,
        TRY_TO_NUMBER(ri.PAYLOAD:qty_on_hand::string)    AS QTY_ON_HAND,
        TRY_TO_NUMBER(ri.PAYLOAD:reorder_point::string)  AS REORDER_POINT,
        TRY_TO_TIMESTAMP_NTZ(ri.PAYLOAD:inventory_ts::string) AS INVENTORY_TS,
        ri._LOADED_AT,
        ROW_NUMBER() OVER (
            PARTITION BY ri.PAYLOAD:product_id::string,
                         ri.PAYLOAD:warehouse_id::string
            ORDER BY COALESCE(
                TRY_TO_TIMESTAMP_NTZ(ri.PAYLOAD:inventory_ts::string),
                ri._LOADED_AT
            ) DESC
        ) AS RN_LATEST
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_INVENTORY ri
    -- Optional pruning window on load time if desired for maintenance/perf
    -- WHERE ri._LOADED_AT >= DATEADD(day, -365, CURRENT_TIMESTAMP())
),

sales_velocity AS (
    SELECT
        s.PAYLOAD:product_id::string AS PRODUCT_ID,
        AVG(TRY_TO_NUMBER(s.PAYLOAD:daily_units_sold::string)) AS DAILY_VELOCITY
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_SALES s
    -- Optional: restrict to recent sales history for more relevant velocity
    -- WHERE s._LOADED_AT >= DATEADD(day, -90, CURRENT_TIMESTAMP())
    GROUP BY
        s.PAYLOAD:product_id::string
)

SELECT
    ai.PRODUCT_ID,
    ai.WAREHOUSE_ID,
    ai.QTY_ON_HAND,
    ai.REORDER_POINT,
    ai.INVENTORY_TS,
    sv.DAILY_VELOCITY,
    CASE
        WHEN ai.QTY_ON_HAND IS NULL
            OR ai.REORDER_POINT IS NULL
            THEN 'UNKNOWN'
        WHEN ai.QTY_ON_HAND <= ai.REORDER_POINT
            THEN 'CRITICAL'
        WHEN ai.QTY_ON_HAND <= ai.REORDER_POINT * 1.5
            THEN 'LOW_STOCK'
        WHEN sv.DAILY_VELOCITY > 0
             AND ai.QTY_ON_HAND / sv.DAILY_VELOCITY > 180
            THEN 'OVERSTOCK'
        ELSE 'HEALTHY'
    END AS STOCK_STATUS
FROM all_inventory ai
LEFT JOIN sales_velocity sv
    ON sv.PRODUCT_ID = ai.PRODUCT_ID
WHERE ai.RN_LATEST = 1;
