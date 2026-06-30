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
WITH customer_sales AS (
    SELECT
        fs.CUSTOMER_ID,
        fs.CUSTOMER_REGION,
        fs.CUSTOMER_TIER,
        COUNT(*)                           AS TOTAL_ORDERS,
        SUM(fs.NET_AMOUNT)                 AS LIFETIME_VALUE,
        MAX(fs.ORDER_DATE)                 AS LAST_ORDER_DATE,
        MIN(fs.ORDER_DATE)                 AS FIRST_ORDER_DATE,
        DATEDIFF('day',
                 MIN(fs.ORDER_DATE),
                 MAX(fs.ORDER_DATE))       AS CUSTOMER_TENURE_DAYS
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
    CUSTOMER_TENURE_DAYS
FROM customer_sales;