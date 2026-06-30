CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimized product performance view.

  Key optimizations:
  - Eliminate three full scans of FACT_SALES by aggregating once with a derived PERIOD_TYPE.
  - Factor out repeated DATEADD/CURRENT_DATE expressions into a single CTE for clarity and reuse.
  - Compute base aggregates once per PRODUCT and PERIOD_TYPE, then derive PRICE_TIER from those
    aggregates instead of re-embedding SUM() expressions in CASE logic.
  - Keep UNION ALL semantics while relying on a single GROUP BY over a CASE expression.
*/
WITH date_bounds AS (
    SELECT
        CURRENT_DATE()                                        AS today,
        DATEADD('month', -3,  CURRENT_DATE())                 AS cur_q_start,
        DATEADD('month', -6,  CURRENT_DATE())                 AS prev_q_start,
        DATEADD('month', -12, CURRENT_DATE())                 AS year_ago_q_start,
        DATEADD('month', -15, CURRENT_DATE())                 AS year_ago_prev_q_start
),
classified_sales AS (
    SELECT
        CASE
            WHEN fs.ORDER_DATE >= db.cur_q_start
             AND fs.ORDER_DATE <  db.today
                THEN 'CURRENT_QUARTER'
            WHEN fs.ORDER_DATE >= db.prev_q_start
             AND fs.ORDER_DATE <  db.cur_q_start
                THEN 'PREVIOUS_QUARTER'
            WHEN fs.ORDER_DATE >= db.year_ago_prev_q_start
             AND fs.ORDER_DATE <  db.year_ago_q_start
                THEN 'YEAR_AGO_QUARTER'
            ELSE NULL
        END AS PERIOD_TYPE,
        fs.PRODUCT_ID,
        fs.PRODUCT_CATEGORY,
        fs.PRODUCT_SUBCATEGORY,
        fs.NET_AMOUNT,
        fs.QUANTITY,
        fs.ORDER_ID
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    CROSS JOIN date_bounds db
    WHERE fs.ORDER_DATE >= db.year_ago_prev_q_start
      AND fs.ORDER_DATE <  db.today
),
product_period_agg AS (
    SELECT
        PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)               AS REVENUE,
        COUNT(DISTINCT ORDER_ID)      AS UNIQUE_ORDERS,
        SUM(QUANTITY)                 AS UNITS_SOLD
    FROM classified_sales
    WHERE PERIOD_TYPE IS NOT NULL
    GROUP BY
        PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY
)
SELECT
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY,
    REVENUE,
    UNIQUE_ORDERS,
    UNITS_SOLD,
    CASE
        WHEN UNITS_SOLD > 0 THEN
            CASE
                WHEN REVENUE / NULLIF(UNITS_SOLD, 0) > 100 THEN 'HIGH'
                WHEN REVENUE / NULLIF(UNITS_SOLD, 0) > 50  THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE 'NONE'
    END AS PRICE_TIER
FROM product_period_agg;