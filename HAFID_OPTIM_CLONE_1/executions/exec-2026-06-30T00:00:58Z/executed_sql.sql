CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH AS
/*
  Reconstructed and optimized based on provided fragments.
  Assumptions (kept minimal to avoid behavior changes):
  - all_inventory CTE captures latest inventory snapshot per product/warehouse
  - sales_velocity CTE provides daily velocity per product
  - STOCK_STATUS logic is preserved exactly as in the fragment
*/
WITH all_inventory AS (
    SELECT
        -- Core product and warehouse identifiers
        ri.PAYLOAD:product_id::STRING   AS PRODUCT_ID,
        ri.PAYLOAD:warehouse_id::STRING AS WAREHOUSE_ID,

        -- Inventory metrics (exact casting preserved for numeric safety)
        ri.PAYLOAD:qty_on_hand::NUMBER(38, 6)   AS QTY_ON_HAND,
        ri.PAYLOAD:reorder_point::NUMBER(38, 6) AS REORDER_POINT,

        -- Snapshot timestamp and row_number used to define latest snapshot
        ri.PAYLOAD:snapshot_ts::TIMESTAMP_NTZ   AS SNAPSHOT_TS,
        ROW_NUMBER() OVER (
            PARTITION BY ri.PAYLOAD:product_id::STRING,
                         ri.PAYLOAD:warehouse_id::STRING
            ORDER BY ri.PAYLOAD:snapshot_ts::TIMESTAMP_NTZ DESC
        ) AS RN_LATEST
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_INVENTORY ri
    -- Optional filter on recent data could be here; omitted to avoid semantic change
),

sales_velocity AS (
    /*
       Daily velocity per product.
       Leave logic simple and explicit; do not alter semantics.
    */
    SELECT
        o.PAYLOAD:product_id::STRING AS PRODUCT_ID,
        /*
           DAILY_VELOCITY is defined as average daily quantity sold.
           Using explicit casts and division to preserve behavior.
        */
        (SUM(o.PAYLOAD:quantity::NUMBER(38, 6))
         / NULLIF(DATEDIFF(
                'day',
                MIN(o.PAYLOAD:order_date::DATE),
                MAX(o.PAYLOAD:order_date::DATE)
            ) + 1, 0)
        ) AS DAILY_VELOCITY
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_ORDERS o
    GROUP BY
        o.PAYLOAD:product_id::STRING
)

SELECT
    ai.PRODUCT_ID,
    ai.WAREHOUSE_ID,
    ai.QTY_ON_HAND,
    ai.REORDER_POINT,
    sv.DAILY_VELOCITY,

    /*
       STOCK_STATUS logic (exactly preserved as given):
       - LOW_STOCK when QTY_ON_HAND <= REORDER_POINT * 1.5
       - OVERSTOCK when DAILY_VELOCITY > 0 AND coverage > 180 days
       - Otherwise HEALTHY
    */
    CASE
        WHEN ai.QTY_ON_HAND <= ai.REORDER_POINT * 1.5 THEN 'LOW_STOCK'
        WHEN sv.DAILY_VELOCITY > 0
             AND ai.QTY_ON_HAND / sv.DAILY_VELOCITY > 180 THEN 'OVERSTOCK'
        ELSE 'HEALTHY'
    END AS STOCK_STATUS
FROM all_inventory AS ai
LEFT JOIN sales_velocity AS sv
    ON sv.PRODUCT_ID = ai.PRODUCT_ID
WHERE ai.RN_LATEST = 1;