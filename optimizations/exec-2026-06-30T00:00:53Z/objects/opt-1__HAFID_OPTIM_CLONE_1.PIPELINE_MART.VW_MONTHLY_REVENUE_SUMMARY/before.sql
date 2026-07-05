create or replace view VW_MONTHLY_REVENUE_SUMMARY(
	REVENUE_MONTH,
	PRODUCT_CATEGORY,
	CUSTOMER_REGION,
	CHANNEL,
	TOTAL_REVENUE,
	TOTAL_GROSS,
	ORDER_COUNT,
	AVG_DISCOUNT
) as
SELECT
    TO_CHAR(DATE_TRUNC('month', ORDER_DATE), 'YYYY-MM')                  AS REVENUE_MONTH,
    PRODUCT_CATEGORY,
    CUSTOMER_REGION,
    CHANNEL,
    /* Cast once to NUMBER; adjust precision/scale if needed */
    SUM(NET_AMOUNT::NUMBER)                                             AS TOTAL_REVENUE,
    SUM(GROSS_AMOUNT::NUMBER)                                           AS TOTAL_GROSS,
    COUNT(*)                                                            AS ORDER_COUNT,
    AVG(DISCOUNT_PCT::NUMBER)                                          AS AVG_DISCOUNT
FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
WHERE
    ORDER_DATE >= DATE '2020-01-01'          -- replaces YEAR(ORDER_DATE) >= 2020
    AND STATUS <> 'cancelled'
GROUP BY
    TO_CHAR(DATE_TRUNC('month', ORDER_DATE), 'YYYY-MM'),
    PRODUCT_CATEGORY,
    CUSTOMER_REGION,
    CHANNEL
HAVING
    SUM(NET_AMOUNT::NUMBER) > 0;
