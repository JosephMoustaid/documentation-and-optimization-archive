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
        d1.order_date,
        SUM(d1.order_total) AS daily_total
    FROM OPT_LAB_CLONE_3.RETAIL.ORDERS d1
    GROUP BY d1.order_date
) agg;