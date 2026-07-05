CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS AS
SELECT
 s.customer_id,
 s.first_name,
 s.last_name,
 s.total_spent,
 (SELECT COUNT() FROM orders o
 WHERE o.customer_id = s.customer_id
 AND o.status = 'RETURNED') AS returned_orders
FROM v_customer_order_summary s
WHERE s.total_spent > 0
ORDER BY s.total_spent DESC;
