CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
    c.*,
    COUNT(o.order_id) AS num_orders,
    SUM(o.order_total) AS total_spent,
    MAX(o.order_date) AS last_order
FROM retail.customers c
LEFT JOIN retail.orders o
    ON o.customer_id = c.customer_id
GROUP BY
    c.*