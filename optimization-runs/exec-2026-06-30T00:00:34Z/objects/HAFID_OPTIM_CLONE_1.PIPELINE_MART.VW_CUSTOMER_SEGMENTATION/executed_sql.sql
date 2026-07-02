CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION AS
/*
  Optimizations applied
  ---------------------
  1) Performance: Replaced multiple correlated subqueries on FACT_SALES
     with a single grouped aggregation (customer_agg). This reduces repeated
     scans and joins, significantly improving performance.

  2) Logic simplification: Used STATUS IN (...) instead of repetitive OR
     expressions. This is more readable and often easier for the optimizer.

  3) Tenure calculation: Compute FIRST_ORDER_DATE and LAST_ORDER_DATE once
     in the CTE, then use DATEDIFF directly on those columns. Semantics
     remain identical to the original, but with fewer subqueries.

  4) DISTINCT removal: DISTINCT on the outer SELECT is no longer required
     because GROUP BY in the CTE already enforces one row per
     (CUSTOMER_ID, CUSTOMER_REGION, CUSTOMER_TIER).
*/
WITH customer_agg AS (
    SELECT
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER,
        COUNT(*)           AS TOTAL_ORDERS,
        SUM(fs.NET_AMOUNT) AS LIFETIME_VALUE,
        MIN(fs.ORDER_DATE) AS FIRST_ORDER_DATE,
        MAX(fs.ORDER_DATE) AS LAST_ORDER_DATE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
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
FROM customer_agg;
