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
  Optimized customer segmentation view.

  Key optimizations:
  - Remove correlated scalar subqueries that re-scan FACT_SALES for each row.
  - Aggregate once per CUSTOMER_ID in a CTE and join back, dramatically reducing work.
  - Use a concise IN predicate for status filtering.
  - Compute tenure using MIN/MAX within the same aggregation, avoiding duplicated logic.
*/
WITH customer_sales AS (
    SELECT
        fs.CUSTOMER_ID,
        COUNT(*)                          AS TOTAL_ORDERS,
        SUM(fs.NET_AMOUNT)                AS LIFETIME_VALUE,
        MAX(fs.ORDER_DATE)                AS LAST_ORDER_DATE,
        MIN(fs.ORDER_DATE)                AS FIRST_ORDER_DATE,
        DATEDIFF('day',
                 MIN(fs.ORDER_DATE),
                 MAX(fs.ORDER_DATE))      AS CUSTOMER_TENURE_DAYS
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
    WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
    GROUP BY fs.CUSTOMER_ID
)
SELECT
    fs.CUSTOMER_ID,
    fs.CUSTOMER_REGION,
    fs.CUSTOMER_TIER,
    cs.TOTAL_ORDERS,
    cs.LIFETIME_VALUE,
    cs.LAST_ORDER_DATE,
    cs.FIRST_ORDER_DATE,
    cs.CUSTOMER_TENURE_DAYS
FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES fs
JOIN customer_sales cs
    ON cs.CUSTOMER_ID = fs.CUSTOMER_ID
WHERE fs.STATUS IN ('completed', 'shipped', 'delivered', 'processing')
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY fs.CUSTOMER_ID
    ORDER BY fs.CUSTOMER_ID
) = 1;
