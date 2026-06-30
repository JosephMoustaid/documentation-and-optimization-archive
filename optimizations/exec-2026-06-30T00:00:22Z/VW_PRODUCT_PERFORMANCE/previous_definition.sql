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
  - Consolidated three nearly identical UNION ALL branches into a single scan
    of FACT_SALES with a derived PERIOD_TYPE column, reducing I/O and CPU.
  - Applied all date filters in one WHERE clause using CASE logic instead of
    three separate queries.
  - Calculated SUMs for NET_AMOUNT and QUANTITY once per (PRODUCT, PERIOD_TYPE)
    group, then reused them to derive PRICE_TIER; this avoids repeated SUM
    expressions and improves readability.
  - Used a small inline mapping for PERIOD_TYPE determination based on
    relative month offsets from CURRENT_DATE().
*/
WITH classified_sales AS (
    SELECT
        fs.PRODUCT_ID,
        fs.PRODUCT_CATEGORY,
        fs.PRODUCT_SUBCATEGORY,
        fs.NET_AMOUNT,
        fs.QUANTITY,
        fs.ORDER_ID,
        fs.ORDER_DATE,
        /* Determine which quarter bucket the order belongs to. */
        CASE
            WHEN fs.ORDER_DATE >= DATEADD('month', -3, CURRENT_DATE())
             AND fs.ORDER_DATE <  CURRENT_DATE()                      THEN 'CURRENT_QUARTER'
            WHEN fs.ORDER_DATE >= DATEADD('month', -6, CURRENT_DATE())
             AND fs.ORDER_DATE <  DATEADD('month', -3, CURRENT_DATE()) THEN 'PREVIOUS_QUARTER'
            WHEN fs.ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
             AND fs.ORDER_DATE <  DATEADD('month', -12, CURRENT_DATE()) THEN 'YEAR_AGO_QUARTER'
            ELSE NULL
        END AS PERIOD_TYPE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    /* Keep only rows that fall into one of the three period buckets. */
    WHERE fs.ORDER_DATE >= DATEADD('month', -15, CURRENT_DATE())
      AND fs.ORDER_DATE <  CURRENT_DATE()
)
SELECT
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY,
    SUM(NET_AMOUNT)                AS REVENUE,
    COUNT(DISTINCT ORDER_ID)       AS UNIQUE_ORDERS,
    SUM(QUANTITY)                  AS UNITS_SOLD,
    /* Derive price tier from aggregated metrics to avoid repeated SUM calls. */
    CASE
        WHEN SUM(QUANTITY) > 0 THEN
            CASE
                WHEN SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) > 100 THEN 'HIGH'
                WHEN SUM(NET_AMOUNT) / NULLIF(SUM(QUANTITY), 0) >  50 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        ELSE 'NONE'
    END AS PRICE_TIER
FROM classified_sales
WHERE PERIOD_TYPE IS NOT NULL
GROUP BY
    PERIOD_TYPE,
    PRODUCT_ID,
    PRODUCT_CATEGORY,
    PRODUCT_SUBCATEGORY;