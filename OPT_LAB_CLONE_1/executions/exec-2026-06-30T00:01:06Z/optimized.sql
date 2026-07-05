CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
  Optimization notes (behavior-preserving):
  - Replaced three correlated scalar subqueries with a single LEFT JOIN to an aggregated
    derived table, eliminating repeated scans of ORDERS while preserving NULL behavior.
  - GROUP BY only customer_id in the derived table; customers without orders still appear
    with NULL metrics (LEFT JOIN), matching original semantics.
  - Preserved output columns via c.* projection and identical aggregate calculations.
*/
SELECT
    c.*,
    o_agg.num_orders,
    o_agg.total_spent,
    o_agg.last_order
FROM customers AS c
LEFT JOIN (
    SELECT
        o.customer_id,
        COUNT(*)              AS num_orders,
        SUM(o.order_total)    AS total_spent,
        MAX(o.order_date)     AS last_order
    FROM orders AS o
    GROUP BY o.customer_id
) AS o_agg
    ON o_agg.customer_id = c.customer_id;
