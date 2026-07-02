CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimizations applied
  ---------------------
  1) Common aggregation CTE: Scan FACT_SALES once and aggregate by
     PRODUCT_* and a derived PERIOD_TYPE, instead of three separate
     UNION ALL queries. This reduces I/O and planning overhead.

  2) Centralized price tier logic: Compute unit_price once in the CTE
     and derive PRICE_TIER from it in a single CASE expression, improving
     readability and avoiding repeated SUM() expressions.

  3) Date bucketing via CASE: Use a single CASE on ORDER_DATE to assign
     rows to CURRENT_QUARTER, PREVIOUS_QUARTER, or YEAR_AGO_QUARTER,
     matching original date ranges.

  4) Stable quarter windows: Preserve the original rolling 3‑month
     windows using the same DATEADD logic.
*/
WITH sales_quarters AS (
    SELECT
        /* Period bucketing matching original filters */
        CASE
            WHEN ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
                 AND ORDER_DATE <  CURRENT_DATE()
                THEN 'CURRENT_QUARTER'
            WHEN ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
                 AND ORDER_DATE <  DATEADD('month', -3, CURRENT_DATE())
                THEN 'PREVIOUS_QUARTER'
            WHEN ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
                 AND ORDER_DATE <  DATEADD('month', -12, CURRENT_DATE())
                THEN 'YEAR_AGO_QUARTER'
            ELSE NULL
        END AS PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        NET_AMOUNT,
        QUANTITY,
        ORDER_ID
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
      AND ORDER_DATE <  CURRENT_DATE()
)
, product_agg AS (
    SELECT
        PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                               AS REVENUE,
        COUNT(DISTINCT ORDER_ID)                      AS UNIQUE_ORDERS,
        SUM(QUANTITY)                                 AS UNITS_SOLD,
        /* Precompute unit price safely */
        SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0)    AS UNIT_PRICE
    FROM sales_quarters
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
                WHEN UNIT_PRICE > 100 THEN 'HIGH'
                WHEN UNIT_PRICE >  50 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE 'NONE'
    END AS PRICE_TIER
FROM product_agg;