create or replace view VW_PRODUCT_PERFORMANCE(
	PERIOD_TYPE,
	PRODUCT_ID,
	PRODUCT_CATEGORY,
	PRODUCT_SUBCATEGORY,
	REVENUE,
	UNIQUE_ORDERS,
	UNITS_SOLD,
	PRICE_TIER
) as
/*
  Optimizations applied:
  - Consolidated three almost-identical SELECTs into a single scan of FACT_SALES
    using a CASE expression to derive PERIOD_TYPE.
  - This removes multiple passes over FACT_SALES and repeated DATEADD calls,
    significantly reducing I/O and planner overhead.
  - Reused aggregated values (REVENUE, UNITS_SOLD) for PRICE_TIER calculation
    instead of recomputing SUM() expressions.
*/
WITH base AS (
    SELECT
        /* Derive the period label once via CASE */
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
        END AS PERIOD_TYPE,
        PRODUCT_ID,
        PRODUCT_CATEGORY,
        PRODUCT_SUBCATEGORY,
        NET_AMOUNT,
        ORDER_ID,
        QUANTITY
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
      AND ORDER_DATE <  CURRENT_DATE()
      /* Optional: filter to rows that fall into at least one defined period */
      AND (
            ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
         OR ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE()) AND ORDER_DATE < DATEADD('month', -3, CURRENT_DATE())
         OR ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE()) AND ORDER_DATE < DATEADD('month', -12, CURRENT_DATE())
          )
)
SELECT
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY,
    SUM(NET_AMOUNT)              AS REVENUE,
    COUNT(DISTINCT ORDER_ID)     AS UNIQUE_ORDERS,
    SUM(QUANTITY)                AS UNITS_SOLD,
    /* Use aggregated values to compute price tier once per group */
    CASE
        WHEN SUM(QUANTITY) > 0 THEN
            CASE
                WHEN SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) > 100 THEN 'HIGH'
                WHEN SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) > 50  THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE 'NONE'
    END AS PRICE_TIER
FROM base
WHERE PERIOD_TYPE IS NOT NULL
GROUP BY
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY;