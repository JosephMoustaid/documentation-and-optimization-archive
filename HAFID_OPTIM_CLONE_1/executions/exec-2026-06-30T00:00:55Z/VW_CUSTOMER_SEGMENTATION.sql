CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION AS
/*
  Optimizations applied (no change in semantics):
  - Replaced multiple correlated scalar subqueries with a single aggregation
    grouped by CUSTOMER_ID, then joined back. This preserves results while
    scanning FACT_SALES only once per customer instead of multiple times.
  - Centralized the status filter so that all metrics are computed over the
    same filtered FACT_SALES set as in the original query.
  - Kept DISTINCT on (CUSTOMER_ID, CUSTOMER_REGION, CUSTOMER_TIER) to
    preserve row cardinality and output exactly as before.
*/
WITH BASE AS (
    SELECT
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
    GROUP BY
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER
),
AGG AS (
    SELECT
        fs.CUSTOMER_ID,
        COUNT(*)            AS TOTAL_ORDERS,
        SUM(fs.NET_AMOUNT)  AS LIFETIME_VALUE,
        MAX(fs.ORDER_DATE)  AS LAST_ORDER_DATE,
        MIN(fs.ORDER_DATE)  AS FIRST_ORDER_DATE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
    GROUP BY
        fs.CUSTOMER_ID
)
SELECT DISTINCT
    b.CUSTOMER_ID,
    b.CUSTOMER_REGION,
    b.CUSTOMER_TIER,
    a.TOTAL_ORDERS,
    a.LIFETIME_VALUE,
    a.LAST_ORDER_DATE,
    a.FIRST_ORDER_DATE,
    DATEDIFF('day', a.FIRST_ORDER_DATE, a.LAST_ORDER_DATE) AS CUSTOMER_TENURE_DAYS
FROM BASE b
JOIN AGG a
  ON a.CUSTOMER_ID = b.CUSTOMER_ID;
