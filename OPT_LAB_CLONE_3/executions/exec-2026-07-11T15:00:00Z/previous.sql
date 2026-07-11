create or replace view V_CUSTOMER_ORDER_SUMMARY(
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	EMAIL,
	COUNTRY,
	SIGNUP_DATE,
	IS_ACTIVE,
	LIFETIME_VALUE,
	NUM_ORDERS,
	TOTAL_SPENT,
	LAST_ORDER
) as
SELECT
    c.*,
    (SELECT COUNT(*)      FROM orders o WHERE o.customer_id = c.customer_id) AS num_orders,
    (SELECT SUM(order_total) FROM orders o WHERE o.customer_id = c.customer_id) AS total_spent,
    (SELECT MAX(order_date)  FROM orders o WHERE o.customer_id = c.customer_id) AS last_order
FROM customers c;
