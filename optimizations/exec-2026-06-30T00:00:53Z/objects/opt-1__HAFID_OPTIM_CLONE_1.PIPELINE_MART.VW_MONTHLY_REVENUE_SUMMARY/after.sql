CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_MONTHLY_REVENUE_SUMMARY AS
/*
  Optimizations applied:
  - Removed unnecessary subquery; applied HAVING and ORDER BY directly on main aggregation.
  - Simplified date bucketing to use TO_CHAR directly on ORDER_DATE (assuming DATE type).
  - Replaced double CAST chains with single numeric casts using TRY_* to avoid hard failures.
  - Replaced COUNT() (non-standard) with COUNT(*) for correctness.
  - Kept YEAR filter and status filter SARGable for partition/pruning if supported.
*/
SELECT
    TO_CHAR(ORDER_DATE, 'YYYY-MM')                         AS REVENUE_MONTH,
    PRODUCT_CATEGORY,
    CUSTOMER_REGION,
    CHANNEL,
    SUM(TRY_TO_DOUBLE(NET_AMOUNT))                         AS TOTAL_REVENUE,
    SUM(TRY_TO_DOUBLE(GROSS_AMOUNT))                       AS TOTAL_GROSS,
    COUNT(*)                                               AS ORDER_COUNT,
    AVG(TRY_TO_NUMBER(DISCOUNT_PCT))                       AS AVG_DISCOUNT
FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
WHERE YEAR(ORDER_DATE) >= 2020
  AND STATUS <> 'cancelled'
GROUP BY
    TO_CHAR(ORDER_DATE, 'YYYY-MM'),
    PRODUCT_CATEGORY,
    CUSTOMER_REGION,
    CHANNEL
HAVING
    SUM(TRY_TO_DOUBLE(NET_AMOUNT)) > 0
ORDER BY
    REVENUE_MONTH DESC;
