CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
 c.,
 (SELECT COUNT() FROM orders o WHERE o.customer_id = c.customer_id) AS num_orders,
 (SELECT SUM(order_total) FROM orders o WHERE o.customer_id = c.customer_id) AS total_spent,
 (SELECT MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id) AS last_order
FROM customers c;
