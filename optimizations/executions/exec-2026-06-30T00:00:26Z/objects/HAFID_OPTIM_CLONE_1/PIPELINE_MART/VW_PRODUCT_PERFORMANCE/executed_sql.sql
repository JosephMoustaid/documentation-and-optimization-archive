CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimized VIEW: VW_PRODUCT_PERFORMANCE

  Key optimizations:
  - Eliminate repeated full scans of FACT_SALES by aggregating once and pivoting
    into period buckets via CASE expressions.
  - Precompute per-row period classification (PERIOD_TYPE) and then aggregate,
    instead of three separate UNION ALL branches with overlapping logic.
  - Avoid repeated SUM/CASE logic by computing revenue and units once per row
    and aggregating by (PERIOD_TYPE, PRODUCT_ID, PRODUCT_CATEGORY, PRODUCT_SUBCATEGORY).
  - Keep the PRICE_TIER derivation centralized and consistent across periods.
*/
WITH classified_sales AS (
    SELECT
        fs.PRODUCT_ID,
        fs.PRODUCT_CATEGORY,
        fs.PRODUCT_SUBCATEGORY,
        fs.NET_AMOUNT,
        fs.QUANTITY,
        fs.ORDER_ID,
        CASE
            WHEN fs.ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
                 AND fs.ORDER_DATE < CURRENT_DATE()
                THEN 'CURRENT_QUARTER'
            WHEN fs.ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
                 AND fs.ORDER_DATE < DATEADD('month', -3, CURRENT_DATE())
                THEN 'PREVIOUS_QUARTER'
            WHEN fs.ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
                 AND fs.ORDER_DATE < DATEADD('month', -12, CURRENT_DATE())
                THEN 'YEAR_AGO_QUARTER'
            ELSE NULL
        END AS PERIOD_TYPE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
      AND fs.ORDER_DATE < CURRENT_DATE()
),
aggregated AS (
    SELECT
        PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                           AS REVENUE,
        COUNT(DISTINCT ORDER_ID)                  AS UNIQUE_ORDERS,
        SUM(QUANTITY)                             AS UNITS_SOLD,
        /*
          Derive PRICE_TIER once per (period, product) using aggregated values.
        */
        CASE
            WHEN SUM(QUANTITY) > 0 THEN
                CASE
                    WHEN SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) > 100 THEN 'HIGH'
                    WHEN SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) > 50  THEN 'MEDIUM'
                    ELSE 'LOW'
                END
            ELSE 'NONE'
        END AS PRICE_TIER
    FROM classified_sales
    WHERE PERIOD_TYPE IS NOT NULL
    GROUP BY PERIOD_TYPE, PRODUCT_ID, PRODUCT_CATEGORY, PRODUCT_SUBCATEGORY
)
SELECT
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY,
    REVENUE,
    UNIQUE_ORDERS,
    UNITS_SOLD,
    PRICE_TIER
FROM aggregated;
