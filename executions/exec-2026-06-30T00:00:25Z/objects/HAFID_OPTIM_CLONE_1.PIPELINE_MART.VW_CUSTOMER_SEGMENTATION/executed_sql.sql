CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION AS
/*
  Optimized VIEW: VW_CUSTOMER_SEGMENTATION

  Key optimizations:
  - Replace multiple correlated scalar subqueries with a single aggregation
    over FACT_SALES grouped by CUSTOMER_ID.
  - Remove SELECT DISTINCT and leverage GROUP BY for deduplication.
  - Use a SARGable status filter with IN instead of multiple OR predicates.
  - Compute tenure with DATEDIFF directly on aggregated MIN/MAX dates.
  - Restrict aggregation to relevant (completed/shipped/delivered/processing) rows.
*/
WITH filtered_sales AS (
    SELECT
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER,
        fs.STATUS,
        fs.NET_AMOUNT,
        fs.ORDER_DATE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
),
customer_agg AS (
    SELECT
        CUSTOMER_ID,
        /* Assuming region/tier are stable per customer; use MAX to collapse if needed */
        MAX(CUSTOMER_REGION) AS CUSTOMER_REGION,
        MAX(CUSTOMER_TIER)   AS CUSTOMER_TIER,
        COUNT(*)             AS TOTAL_ORDERS,
        SUM(NET_AMOUNT)      AS LIFETIME_VALUE,
        MAX(ORDER_DATE)      AS LAST_ORDER_DATE,
        MIN(ORDER_DATE)      AS FIRST_ORDER_DATE,
        DATEDIFF('day', MIN(ORDER_DATE), MAX(ORDER_DATE)) AS CUSTOMER_TENURE_DAYS
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
    CUSTOMER_TENURE_DAYS
FROM customer_agg;
