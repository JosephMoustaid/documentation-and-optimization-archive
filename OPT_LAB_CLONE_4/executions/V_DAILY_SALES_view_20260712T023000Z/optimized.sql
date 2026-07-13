CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES AS
SELECT
    o.order_date,
    SUM(o.order_total) AS daily_total,
    -- Use the daily_total aggregate in the window function instead of re-aggregating
    SUM(SUM(o.order_total)) OVER (
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
GROUP BY
    o.order_date;