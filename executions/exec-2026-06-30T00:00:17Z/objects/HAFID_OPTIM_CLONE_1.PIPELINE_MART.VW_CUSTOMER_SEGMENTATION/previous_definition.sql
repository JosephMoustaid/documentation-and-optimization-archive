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
    over FACT_SALES grouped by CUSTOMER_ID.
  - Removed SELECT DISTINCT; uniqueness is guaranteed by GROUP BY CUSTOMER_ID.
  - Applied the status filter once in the base set instead of inside subqueries.
  - Computed tenure using MIN/ MAX from the same aggregated set, avoiding
    repeated scans of FACT_SALES.
  - This significantly reduces I/O and CPU, and improves planner optimizations
    on FACT_SALES.
*/
WITH customer_sales AS (
    SELECT
        fs.CUSTOMER_ID,
        /* Assuming region and tier are stable per customer; if not,
           you may need more precise logic (e.g. most recent, max tier, etc.). */
        ANY_VALUE(fs.CUSTOMER_REGION) AS CUSTOMER_REGION,
        ANY_VALUE(fs.CUSTOMER_TIER)   AS CUSTOMER_TIER,
        COUNT(*)                      AS TOTAL_ORDERS,
        SUM(fs.NET_AMOUNT)            AS LIFETIME_VALUE,
        MIN(fs.ORDER_DATE)            AS FIRST_ORDER_DATE,
        MAX(fs.ORDER_DATE)            AS LAST_ORDER_DATE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
    GROUP BY fs.CUSTOMER_ID
)
SELECT
    cs.CUSTOMER_ID,
    cs.CUSTOMER_REGION,
    cs.CUSTOMER_TIER,
    cs.TOTAL_ORDERS,
    cs.LIFETIME_VALUE,
    cs.LAST_ORDER_DATE,
    cs.FIRST_ORDER_DATE,
    DATEDIFF('day', cs.FIRST_ORDER_DATE, cs.LAST_ORDER_DATE) AS CUSTOMER_TENURE_DAYS
FROM customer_sales cs;
