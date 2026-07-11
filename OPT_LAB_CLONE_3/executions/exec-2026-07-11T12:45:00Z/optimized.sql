CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES AS
SELECT
    order_date,
    daily_total,
    SUM(daily_total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM (
    SELECT
        o.ORDER_DATE      AS order_date,
        SUM(o.ORDER_TOTAL) AS daily_total
    FROM OPT_LAB_CLONE_3.RETAIL.ORDERS o
    GROUP BY o.ORDER_DATE
) AS daily;
