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
  Optimizations:
  - Replaced multiple correlated scalar subqueries with a single aggregation over FACT_SALES,
    dramatically reducing repeated scans and improving performance.
  - Used a CTE to pre-filter to "completed"-like statuses once, then aggregated.
  - Removed DISTINCT by aggregating at CUSTOMER level directly.
  - Ensured tenure calculations use MIN/MAX from the same pre-aggregated dataset.
*/
WITH filtered_sales AS (
    SELECT
        CUSTOMER_ID,
        CUSTOMER_REGION,
        CUSTOMER_TIER,
        NET_AMOUNT,
        ORDER_DATE,
        STATUS
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE STATUS IN ('completed', 'shipped', 'delivered', 'processing')
),
customer_agg AS (
    SELECT
        CUSTOMER_ID,
        /* Assuming region/tier are consistent per customer; use MIN to avoid GROUP BY expansion */
        MIN(CUSTOMER_REGION) AS CUSTOMER_REGION,
        MIN(CUSTOMER_TIER)   AS CUSTOMER_TIER,
        COUNT(*)             AS TOTAL_ORDERS,
        SUM(NET_AMOUNT)      AS LIFETIME_VALUE,
        MAX(ORDER_DATE)      AS LAST_ORDER_DATE,
        MIN(ORDER_DATE)      AS FIRST_ORDER_DATE
    FROM filtered_sales
    GROUP BY CUSTOMER_ID
)
SELECT
    ca.CUSTOMER_ID,
    ca.CUSTOMER_REGION,
    ca.CUSTOMER_TIER,
    ca.TOTAL_ORDERS,
    ca.LIFETIME_VALUE,
    ca.LAST_ORDER_DATE,
    ca.FIRST_ORDER_DATE,
    DATEDIFF('day', ca.FIRST_ORDER_DATE, ca.LAST_ORDER_DATE) AS CUSTOMER_TENURE_DAYS
FROM customer_agg AS ca;
