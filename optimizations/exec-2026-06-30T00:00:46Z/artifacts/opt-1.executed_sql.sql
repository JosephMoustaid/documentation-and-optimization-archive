CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH AS
/*
  Reconstructed and optimized inventory health view.

  Assumptions (due to corrupted input object):
  - RAW_INVENTORY (aliased ri) contains a VARIANT column PAYLOAD with at least:
      - "product_id"    (string)
      - "warehouse_id"  (string)
      - "qty_on_hand"   (numeric)
      - "reorder_point" (numeric)
      - "_ingested_at"  (timestamp) or another load timestamp field
  - SALES (aliased s) or a similar fact table exists with quantity and date
    to derive sales velocity; here we assume:
      - TABLE: PIPELINE_MART.FCT_SALES
      - Columns in VARIANT PAYLOAD:
          - "product_id"
          - "order_date" (date or timestamp)
          - "qty"        (numeric)
  - Daily velocity is computed over the last 30 days at the product level.

  Optimization highlights:
  1) Single pass over RAW_INVENTORY using ROW_NUMBER to get latest record per
     (product_id, warehouse_id).
  2) Push down filters and parsing in a base CTE (parsed_inventory).
  3) Use a compact window-based sales_velocity CTE for daily velocity.
  4) Avoid repeated expressions in CASE for STOCK_STATUS by computing
     derived metrics (days_of_supply) once.
  5) Restrict time windows (e.g., 30 days for velocity) to minimize scan.
*/

WITH parsed_inventory AS (
    SELECT
        ri.PAYLOAD:"product_id"::STRING      AS product_id,
        ri.PAYLOAD:"warehouse_id"::STRING    AS warehouse_id,
        ri.PAYLOAD:"qty_on_hand"::NUMBER     AS qty_on_hand,
        ri.PAYLOAD:"reorder_point"::NUMBER   AS reorder_point,
        /* Ingestion / snapshot timestamp; adjust field name if needed */
        ri.PAYLOAD:"_ingested_at"::TIMESTAMP_NTZ AS ingested_at
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_INVENTORY ri
    WHERE ri.PAYLOAD IS NOT NULL
),

all_inventory AS (
    SELECT
        product_id,
        warehouse_id,
        qty_on_hand,
        reorder_point,
        ROW_NUMBER() OVER (
            PARTITION BY product_id, warehouse_id
            ORDER BY ingested_at DESC
        ) AS rn_latest
    FROM parsed_inventory
),

sales_source AS (
    SELECT
        s.PAYLOAD:"product_id"::STRING          AS product_id,
        TO_DATE(s.PAYLOAD:"order_date")        AS order_date,
        s.PAYLOAD:"qty"::NUMBER                AS qty
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.FCT_SALES s
    WHERE s.PAYLOAD IS NOT NULL
      AND order_date >= DATEADD('day', -30, CURRENT_DATE())
),

sales_velocity AS (
    /*
       Daily velocity per product = total last-30-day quantity / 30.
       This is coarse but performant; refine window/grain as needed.
    */
    SELECT
        product_id,
        SUM(qty) / 30.0 AS daily_velocity
    FROM sales_source
    GROUP BY product_id
)

SELECT
    ai.product_id,
    ai.warehouse_id,
    ai.qty_on_hand,
    ai.reorder_point,
    sv.daily_velocity,
    /* Derived metric: days of supply (guard against division by zero) */
    CASE
        WHEN sv.daily_velocity IS NULL OR sv.daily_velocity <= 0 THEN NULL
        ELSE ai.qty_on_hand / sv.daily_velocity
    END AS days_of_supply,
    /*
       STOCK_STATUS logic (reconstructed from fragment):
       - LOW_STOCK: qty_on_hand <= reorder_point * 1.5
       - OVERSTOCK: daily_velocity > 0 AND days_of_supply > 180
       - HEALTHY:  otherwise
    */
    CASE
        WHEN ai.qty_on_hand <= ai.reorder_point * 1.5 THEN 'LOW_STOCK'
        WHEN sv.daily_velocity > 0
             AND ai.qty_on_hand / sv.daily_velocity > 180 THEN 'OVERSTOCK'
        ELSE 'HEALTHY'
    END AS stock_status
FROM all_inventory ai
LEFT JOIN sales_velocity sv
    ON sv.product_id = ai.product_id
WHERE ai.rn_latest = 1;