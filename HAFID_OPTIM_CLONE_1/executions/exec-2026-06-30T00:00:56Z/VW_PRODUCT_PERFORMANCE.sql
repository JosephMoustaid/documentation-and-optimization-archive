CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_PRODUCT_PERFORMANCE AS
/*
  Optimizations (no semantic changes):
  - Compute the PRICE_TIER metrics from a single aggregated result set
    instead of repeating SUM() expressions in CASE logic.
  - Use a common subquery to avoid recomputing aggregates per UNION arm.
  - Preserve CURRENT_DATE()-relative windows and all original filters.
*/
WITH FACT_BASE AS (
    SELECT
        ORDER_DATE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        NET_AMOUNT,
        ORDER_ID,
        QUANTITY
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
),
AGGREGATES AS (
    SELECT
        /* Label for downstream period filtering */
        CASE
            WHEN ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
             AND ORDER_DATE <  CURRENT_DATE()                       THEN 'CURRENT_QUARTER'
            WHEN ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
             AND ORDER_DATE <  DATEADD('month', -3, CURRENT_DATE()) THEN 'PREVIOUS_QUARTER'
            WHEN ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
             AND ORDER_DATE <  DATEADD('month', -12, CURRENT_DATE()) THEN 'YEAR_AGO_QUARTER'
            ELSE NULL
        END AS PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        SUM(NET_AMOUNT)                      AS REVENUE,
        COUNT(DISTINCT ORDER_ID)             AS UNIQUE_ORDERS,
        SUM(QUANTITY)                        AS UNITS_SOLD,
        SUM(NET_AMOUNT)                      AS TOTAL_NET_AMOUNT,
        SUM(QUANTITY)                        AS TOTAL_QUANTITY
    FROM FACT_BASE
    WHERE (
        ORDER_DATE >= DATEADD('month', -3,  CURRENT_DATE()) AND ORDER_DATE <  CURRENT_DATE()
        OR (ORDER_DATE >= DATEADD('month', -6,  CURRENT_DATE()) AND ORDER_DATE < DATEADD('month', -3,  CURRENT_DATE()))
        OR (ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE()) AND ORDER_DATE < DATEADD('month', -12, CURRENT_DATE()))
    )
    GROUP BY
        CASE
            WHEN ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
             AND ORDER_DATE <  CURRENT_DATE()                       THEN 'CURRENT_QUARTER'
            WHEN ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
             AND ORDER_DATE <  DATEADD('month', -3, CURRENT_DATE()) THEN 'PREVIOUS_QUARTER'
            WHEN ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
             AND ORDER_DATE <  DATEADD('month', -12, CURRENT_DATE()) THEN 'YEAR_AGO_QUARTER'
            ELSE NULL
        END,
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
    /* PRICE_TIER logic preserved exactly, now using pre-aggregated values */
    CASE
        WHEN TOTAL_QUANTITY > 0 THEN
            CASE
                WHEN TOTAL_NET_AMOUNT / NULLIF(TOTAL_QUANTITY, 0) > 100 THEN 'HIGH'
                WHEN TOTAL_NET_AMOUNT / NULLIF(TOTAL_QUANTITY, 0) > 50  THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE 'NONE'
    END AS PRICE_TIER
FROM AGGREGATES
WHERE PERIOD_TYPE IS NOT NULL;
