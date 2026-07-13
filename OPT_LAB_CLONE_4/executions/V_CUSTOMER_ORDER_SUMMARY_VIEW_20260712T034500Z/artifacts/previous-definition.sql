create or replace view V_CUSTOMER_ORDER_SUMMARY(
	CUSTOMER_ID,
	NUM_ORDERS,
	TOTAL_SPENT,
	LAST_ORDER
) as
SELECT
 c.customer_id, -- Explicit customer identifier
 COALESCE(o_agg.num_orders, 0) AS num_orders,
 o_agg.total_spent, -- NULL when no orders
 o_agg.last_order -- NULL when no orders
FROM OPT_LAB_CLONE_4.RETAIL.customers AS c
LEFT JOIN (
 -- Single aggregation over orders instead of three correlated subqueries
 SELECT
 o.customer_id,
 COUNT() AS num_orders, -- Previously COUNT() scalar subquery
 SUM(o.order_total) AS total_spent, -- Previously SUM(order_total) scalar subquery
 MAX(o.order_date) AS last_order -- Previously MAX(order_date) scalar subquery
 FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
 GROUP BY o.customer_id -- One grouped pass over orders
) AS o_agg
 ON o_agg.customer_id = c.customer_id