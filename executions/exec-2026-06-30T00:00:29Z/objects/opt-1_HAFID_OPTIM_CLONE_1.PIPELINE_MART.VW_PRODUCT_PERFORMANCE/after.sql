CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimizations applied:
  - Removed three separate full scans of FACT_SALES by computing all periods
    in a single aggregation with a derived PERIOD_TYPE dimension.
  - Centralized price tier logic; avoided repeated SUM() expressions via
    pre-aggregated metrics and a single CASE expression.
  - Used a derived table to define quarter-like windows relative to CURRENT_DATE,
    then joined once to FACT_SALES, improving reusability and reducing planner work.
*/
WITH period_bounds AS (
    SELECT
        'CURRENT_QUARTER'  AS PERIOD_TYPE,
        DATEADD('month', -3, CURRENT_DATE()) AS START_DATE,
        CURRENT_DATE()                      AS END_DATE
    UNION ALL
    SELECT
        'PREVIOUS_QUARTER' AS PERIOD_TYPE,
        DATEADD('month', -6, CURRENT_DATE()) AS START_DATE,
        DATEADD('month', -3, CURRENT_DATE()) AS END_DATE
    UNION ALL
    SELECT
        'YEAR_AGO_QUARTER' AS PERIOD_TYPE,
        DATEADD('month', -15, CURRENT_DATE()) AS START_DATE,
        DATEADD('month', -12, CURRENT_DATE()) AS END_DATE
),
product_period_agg AS (
    SELECT
        pb.PERIOD_TYPE,
        fs.PRODUCT_ID,
        fs.PRODUCT_CATEGORY,
        fs.PRODUCT_SUBCATEGORY,
        SUM(fs.NET_AMOUNT)          AS REVENUE,
        COUNT(DISTINCT fs.ORDER_ID) AS UNIQUE_ORDERS,
        SUM(fs.QUANTITY)            AS UNITS_SOLD
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    JOIN period_bounds pb
      ON fs.ORDER_DATE >= pb.START_DATE
     AND fs.ORDER_DATE <  pb.END_DATE
    GROUP BY
        pb.PERIOD_TYPE,
        fs.PRODUCT_ID,
        fs.PRODUCT_CATEGORY,
        fs.PRODUCT_SUBCATEGORY
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