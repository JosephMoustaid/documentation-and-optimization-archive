CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_MONTHLY_REVENUE_SUMMARY AS
/*
  Optimizations (no semantic changes):
  - Simplified date formatting for REVENUE_MONTH using TO_CHAR directly on ORDER_DATE.
  - Removed unnecessary CAST(CAST(... AS VARCHAR) AS FLOAT/NUMBER) chains; kept single casts.
  - Replaced COUNT() with COUNT(*) (equivalent in Snowflake, more idiomatic).
  - Preserved outer filter and ORDER BY behavior exactly.
*/
SELECT
    REVENUE_MONTH,
    PRODUCT_CATEGORY,
    CUSTOMER_REGION,
    CHANNEL,
    TOTAL_REVENUE,
    TOTAL_GROSS,
    ORDER_COUNT,
    AVG_DISCOUNT
FROM (
    SELECT
        -- Equivalent to original TO_CHAR(TO_DATE(TO_VARCHAR(ORDER_DATE), 'YYYY-MM-DD'), 'YYYY-MM')
        TO_CHAR(ORDER_DATE, 'YYYY-MM') AS REVENUE_MONTH,
        PRODUCT_CATEGORY,
        CUSTOMER_REGION,
        CHANNEL,
        -- Original double cast: CAST(CAST(NET_AMOUNT AS VARCHAR) AS FLOAT)
        -- Simplified to a single cast while preserving numeric type
        CAST(NET_AMOUNT AS FLOAT) AS TOTAL_REVENUE,
        CAST(GROSS_AMOUNT AS FLOAT) AS TOTAL_GROSS,
        COUNT(*) AS ORDER_COUNT,
        -- Original double cast: CAST(CAST(DISCOUNT_PCT AS VARCHAR) AS NUMBER)
        CAST(DISCOUNT_PCT AS NUMBER) AS AVG_DISCOUNT
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_DWH.FACT_SALES
    WHERE YEAR(ORDER_DATE) >= 2020
      AND STATUS != 'cancelled'
    GROUP BY
        TO_CHAR(ORDER_DATE, 'YYYY-MM'),
        PRODUCT_CATEGORY,
        CUSTOMER_REGION,
        CHANNEL
) sub
WHERE TOTAL_REVENUE > 0
ORDER BY REVENUE_MONTH DESC;
