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
-- Optimized view: remove correlated scalar subqueries by aggregating once per customer
-- Key optimizations:
-- 1) Use a single aggregation over FACT_SALES grouped by CUSTOMER_ID instead of multiple
--    correlated subqueries, eliminating repeated scans and improving performance.
-- 2) Replace OR chain in WHERE with IN list for clarity (Snowflake will normalize it).
-- 3) Use MIN/MAX over ORDER_DATE in same aggregation to derive FIRST/LAST order dates.
-- 4) Compute CUSTOMER_TENURE_DAYS from aggregated FIRST/LAST order dates.

WITH base_sales AS (
    SELECT
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER,
        fs.ORDER_DATE,
        fs.NET_AMOUNT
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
),
agg_sales AS (
    SELECT
        CUSTOMER_ID,
        -- Use ANY_VALUE to pick a representative dimension value per customer.
        -- Assumes CUSTOMER_REGION / CUSTOMER_TIER are consistent per CUSTOMER_ID.
        ANY_VALUE(CUSTOMER_REGION) AS CUSTOMER_REGION,
        ANY_VALUE(CUSTOMER_TIER)    AS CUSTOMER_TIER,
        COUNT(*)                    AS TOTAL_ORDERS,
        SUM(NET_AMOUNT)             AS LIFETIME_VALUE,
        MAX(ORDER_DATE)             AS LAST_ORDER_DATE,
        MIN(ORDER_DATE)             AS FIRST_ORDER_DATE
    FROM base_sales
    GROUP BY CUSTOMER_ID
)
SELECT DISTINCT
    CUSTOMER_ID,
    CUSTOMER_REGION,
    CUSTOMER_TIER,
    TOTAL_ORDERS,
    LIFETIME_VALUE,
    LAST_ORDER_DATE,
    FIRST_ORDER_DATE,
    DATEDIFF('day', FIRST_ORDER_DATE, LAST_ORDER_DATE) AS CUSTOMER_TENURE_DAYS
FROM agg_sales;
