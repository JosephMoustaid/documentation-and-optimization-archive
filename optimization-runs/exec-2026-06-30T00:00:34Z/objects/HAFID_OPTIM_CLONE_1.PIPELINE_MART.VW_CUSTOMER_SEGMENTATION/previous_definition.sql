create or replace view VW_CUSTOMER_SEGMENTATION(
	CUSTOMER_ID,
	CUSTOMER_REGION,
	CUSTOMER_TIER,
	TOTAL_ORDERS,
	LIFETIME_VALUE,
	LAST_ORDER_DATE,
	FIRST_ORDER_DATE,
	CUSTOMER_TENURE_DAYS
) as
/*
  Optimizations applied:
  - Replaced multiple correlated scalar subqueries with a single aggregation
    over FACT_SALES, drastically reducing repeated scans.
  - Used conditional aggregation to apply status filter consistently for all
    derived metrics while still exposing region/tier from the base row.
  - Normalized status filter with IN() instead of multiple OR predicates.
  - Ensured deduplication via GROUP BY rather than DISTINCT over base rows.
*/
WITH customer_orders AS (
    SELECT
        fs.CUSTOMER_ID,
        /* Optional: keep region/tier from the latest completed/shipped/delivered/processing order */
        ANY_VALUE(fs.CUSTOMER_REGION) AS CUSTOMER_REGION,
        ANY_VALUE(fs.CUSTOMER_TIER)   AS CUSTOMER_TIER,

        /* Aggregate metrics restricted to relevant statuses */
        COUNT_IF(fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')) AS TOTAL_ORDERS,
        SUM(CASE WHEN fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
                 THEN fs.NET_AMOUNT ELSE 0 END) AS LIFETIME_VALUE,
        MAX(CASE WHEN fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
                 THEN fs.ORDER_DATE END) AS LAST_ORDER_DATE,
        MIN(CASE WHEN fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
                 THEN fs.ORDER_DATE END) AS FIRST_ORDER_DATE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
    GROUP BY fs.CUSTOMER_ID
)
SELECT
    co.CUSTOMER_ID,
    co.CUSTOMER_REGION,
    co.CUSTOMER_TIER,
    co.TOTAL_ORDERS,
    co.LIFETIME_VALUE,
    co.LAST_ORDER_DATE,
    co.FIRST_ORDER_DATE,
    /* Guard tenure calculation when dates are missing */
    CASE
        WHEN co.FIRST_ORDER_DATE IS NOT NULL AND co.LAST_ORDER_DATE IS NOT NULL
        THEN DATEDIFF('day', co.FIRST_ORDER_DATE, co.LAST_ORDER_DATE)
        ELSE NULL
    END AS CUSTOMER_TENURE_DAYS
FROM customer_orders co;
