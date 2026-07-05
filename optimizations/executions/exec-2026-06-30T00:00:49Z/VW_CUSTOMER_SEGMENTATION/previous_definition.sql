-- Previous definition captured for:
-- HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION

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
  1) Replaces multiple correlated subqueries (each re-scanning FACT_SALES) with a single grouped
     aggregation, reducing scans to one pass over FACT_SALES.
  2) Uses an IN predicate for STATUS to simplify and centralize filtering.
  3) Groups by CUSTOMER_ID, CUSTOMER_REGION, and CUSTOMER_TIER to preserve segmentation attributes
     without needing DISTINCT.
  4) Computes FIRST_ORDER_DATE, LAST_ORDER_DATE, and CUSTOMER_TENURE_DAYS from aggregated dates,
     avoiding repeated MIN/MAX subqueries.
*/

WITH agg_sales AS (
    SELECT
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER,
        COUNT(*)            AS TOTAL_ORDERS,
        SUM(fs.NET_AMOUNT)  AS LIFETIME_VALUE,
        MIN(fs.ORDER_DATE)  AS FIRST_ORDER_DATE,
        MAX(fs.ORDER_DATE)  AS LAST_ORDER_DATE
    FROM
        HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES AS fs
    WHERE
        fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
    GROUP BY
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER
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
FROM
    agg_sales;
