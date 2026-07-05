-- Execution ID: exec-2026-06-30T00:00:49Z
-- Warehouse: ADF_WH
-- Database: HAFID_OPTIM_CLONE_1
-- Object: HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION (VIEW)

CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION AS
/*
  Optimizations applied:
  1) Replaced multiple correlated scalar subqueries with a single aggregation
     over FACT_SALES grouped by CUSTOMER_ID – reduces repeated scans.
  2) Applied the STATUS filter once in a CTE, ensuring consistent criteria
     across all metrics and enabling better pruning.
  3) Aggregated NET_AMOUNT, ORDER_DATE metrics in one pass for better performance.
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
        /* Assuming CUSTOMER_REGION and CUSTOMER_TIER are consistent per customer.
           If not, this picks an arbitrary (but deterministic) value via MIN. */
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
FROM customer_agg ca;
