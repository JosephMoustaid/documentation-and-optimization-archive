CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimizations applied:
  1) Single-pass scan of FACT_SALES using a PERIOD_TYPE CTE instead of three UNION ALL branches,
     reducing repeated table scans.
  2) Centralized calculation of QUARTER_START and PERIOD_TYPE using CASE logic, improving
     maintainability and avoiding duplicated DATEADD expressions.
  3) Pre-aggregated sums for NET_AMOUNT and QUANTITY in a CTE, then derived PRICE_TIER from those
     aggregates to avoid repeated SUM() expressions in CASE.
  4) Preserved exact original time windows:
       - CURRENT_QUARTER     : [CURRENT_DATE - 3 months, CURRENT_DATE)
       - PREVIOUS_QUARTER    : [CURRENT_DATE - 6 months, CURRENT_DATE - 3 months)
       - YEAR_AGO_QUARTER    : [CURRENT_DATE - 15 months, CURRENT_DATE - 12 months)
*/

WITH sales_with_period AS (
    SELECT
        fs.PRODUCT_ID,
        fs.PRODUCT_CATEGORY,
        fs.PRODUCT_SUBCATEGORY,
        fs.NET_AMOUNT,
        fs.QUANTITY,
        fs.ORDER_ID,
        /* Derive the quarter-start boundary used in the original filters */
        CASE
            WHEN fs.ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
                 AND fs.ORDER_DATE <  CURRENT_DATE()
                THEN DATEADD('month', -3, CURRENT_DATE())
            WHEN fs.ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
                 AND fs.ORDER_DATE <  DATEADD('month', -3, CURRENT_DATE())
                THEN DATEADD('month', -6, CURRENT_DATE())
            WHEN fs.ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
                 AND fs.ORDER_DATE <  DATEADD('month', -12, CURRENT_DATE())
                THEN DATEADD('month', -15, CURRENT_DATE())
            ELSE NULL
        END AS quarter_start
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
      AND fs.ORDER_DATE <  CURRENT_DATE()
),
period_labeled AS (
    SELECT
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        NET_AMOUNT,
        QUANTITY,
        ORDER_ID,
        CASE
            WHEN quarter_start = DATEADD('month', -3, CURRENT_DATE())  THEN 'CURRENT_QUARTER'
            WHEN quarter_start = DATEADD('month', -6, CURRENT_DATE())  THEN 'PREVIOUS_QUARTER'
            WHEN quarter_start = DATEADD('month', -15, CURRENT_DATE()) THEN 'YEAR_AGO_QUARTER'
        END AS PERIOD_TYPE
    FROM sales_with_period
    WHERE quarter_start IS NOT NULL
),
agg AS (
    SELECT
        PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                    AS REVENUE,
        COUNT(DISTINCT ORDER_ID)           AS UNIQUE_ORDERS,
        SUM(QUANTITY)                      AS UNITS_SOLD,
        SUM(NET_AMOUNT)      AS sum_net_amount,
        SUM(QUANTITY)        AS sum_quantity
    FROM period_labeled
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
        WHEN sum_quantity > 0 THEN
            CASE
                WHEN sum_net_amount / NULLIF(sum_quantity, 0) > 100 THEN 'HIGH'
                WHEN sum_net_amount / NULLIF(sum_quantity, 0) > 50  THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE 'NONE'
    END AS PRICE_TIER
FROM agg;