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
    over FACT_SALES grouped by CUSTOMER_ID (much fewer scans, better parallelism).
  - Used a single WHERE filter applied once in the aggregated CTE instead of
    repeating it in each subquery.
  - Removed DISTINCT on the outer SELECT; grouping in the CTE already ensures
    one row per CUSTOMER_ID.
  - Computed FIRST_ORDER_DATE, LAST_ORDER_DATE, and CUSTOMER_TENURE_DAYS
    directly from aggregated MIN/MAX values.
*/
WITH filtered_sales AS (
    SELECT
        CUSTOMER_ID,
        CUSTOMER_REGION,
        CUSTOMER_TIER,
        ORDER_DATE,
        NET_AMOUNT,
        STATUS
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE STATUS IN ('completed', 'shipped', 'delivered', 'processing')
),
customer_agg AS (
    SELECT
        CUSTOMER_ID,
        /* Region and tier are assumed to be stable per customer; choose a representative value */
        ANY_VALUE(CUSTOMER_REGION) AS CUSTOMER_REGION,
        ANY_VALUE(CUSTOMER_TIER)   AS CUSTOMER_TIER,
        COUNT(*)                   AS TOTAL_ORDERS,
        SUM(NET_AMOUNT)            AS LIFETIME_VALUE,
        MAX(ORDER_DATE)            AS LAST_ORDER_DATE,
        MIN(ORDER_DATE)            AS FIRST_ORDER_DATE
    FROM filtered_sales
    GROUP BY CUSTOMER_ID
)
SELECT
    CUSTOMER_ID,
    CUSTOMER_REGION,
    CUSTOMER_TIER,
    TOTAL_ORDERS,
    LIFETIME_VALUE,
    LAST_ORDER_DATE,
    FIRST_ORDER_DATE,
    DATEDIFF('day', FIRST_ORDER_DATE, LAST_ORDER_DATE) AS CUSTOMER_TENURE_DAYS
FROM customer_agg;