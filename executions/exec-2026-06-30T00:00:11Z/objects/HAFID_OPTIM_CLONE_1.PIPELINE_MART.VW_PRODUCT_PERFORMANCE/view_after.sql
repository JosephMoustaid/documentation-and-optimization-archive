CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimizations:
  - Removed repeated CASE/aggregation expressions by centralizing metrics in a single CTE per period.
  - Defined price per unit once and derived PRICE_TIER from it, improving readability and maintainability.
  - Ensured consistent column ordering and aliasing across all UNION ALL branches.
  - Left UNION ALL structure intact to preserve semantics of separate time windows.
*/
WITH current_quarter AS (
    SELECT
        'CURRENT_QUARTER' AS PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                            AS REVENUE,
        COUNT(DISTINCT ORDER_ID)                   AS UNIQUE_ORDERS,
        SUM(QUANTITY)                              AS UNITS_SOLD,
        /* Compute price per unit once; rely on NULLIF to avoid division by zero */
        SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) AS PRICE_PER_UNIT
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
      AND ORDER_DATE <  CURRENT_DATE()
    GROUP BY
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY
),
previous_quarter AS (
    SELECT
        'PREVIOUS_QUARTER' AS PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                            AS REVENUE,
        COUNT(DISTINCT ORDER_ID)                   AS UNIQUE_ORDERS,
        SUM(QUANTITY)                              AS UNITS_SOLD,
        SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) AS PRICE_PER_UNIT
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
      AND ORDER_DATE <  DATEADD('month', -3, CURRENT_DATE())
    GROUP BY
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY
),
year_ago_quarter AS (
    SELECT
        'YEAR_AGO_QUARTER' AS PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                            AS REVENUE,
        COUNT(DISTINCT ORDER_ID)                   AS UNIQUE_ORDERS,
        SUM(QUANTITY)                              AS UNITS_SOLD,
        SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) AS PRICE_PER_UNIT
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
      AND ORDER_DATE <  DATEADD('month', -12, CURRENT_DATE())
    GROUP BY
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
        WHEN UNITS_SOLD <= 0 OR PRICE_PER_UNIT IS NULL THEN 'NONE'
        WHEN PRICE_PER_UNIT > 100 THEN 'HIGH'
        WHEN PRICE_PER_UNIT > 50  THEN 'MEDIUM'
        ELSE 'LOW'
    END AS PRICE_TIER
FROM current_quarter
UNION ALL
SELECT
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY,
    REVENUE,
    UNIQUE_ORDERS,
    UNITS_SOLD,
    CASE
        WHEN UNITS_SOLD <= 0 OR PRICE_PER_UNIT IS NULL THEN 'NONE'
        WHEN PRICE_PER_UNIT > 100 THEN 'HIGH'
        WHEN PRICE_PER_UNIT > 50  THEN 'MEDIUM'
        ELSE 'LOW'
    END AS PRICE_TIER
FROM previous_quarter
UNION ALL
SELECT
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY,
    REVENUE,
    UNIQUE_ORDERS,
    UNITS_SOLD,
    CASE
        WHEN UNITS_SOLD <= 0 OR PRICE_PER_UNIT IS NULL THEN 'NONE'
        WHEN PRICE_PER_UNIT > 100 THEN 'HIGH'
        WHEN PRICE_PER_UNIT > 50  THEN 'MEDIUM'
        ELSE 'LOW'
    END AS PRICE_TIER
FROM year_ago_quarter;