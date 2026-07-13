CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES AS
SELECT
    d1.order_date,
    SUM(d1.order_total) AS daily_total,
    SUM(d1.order_total) OVER (
        ORDER BY d1.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM OPT_LAB_CLONE_4.RETAIL.orders AS d1
GROUP BY d1.order_date;
