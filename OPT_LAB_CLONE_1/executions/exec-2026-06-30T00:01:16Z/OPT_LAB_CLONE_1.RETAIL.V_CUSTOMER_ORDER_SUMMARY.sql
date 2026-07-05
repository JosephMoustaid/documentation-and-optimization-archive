CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
  Optimizations (behavior-preserving):
  - Replaced correlated scalar subqueries with a single LEFT JOIN to an aggregated orders subquery.
    This avoids re-scanning the ORDERS table per customer and lets the optimizer use set-based execution.
  - Fully qualified table references for clarity and to avoid dependency on current DB/Schema.
  - Preserved all original output columns and expressions (num_orders, total_spent, last_order) with
    identical semantics.
*/
SELECT
    c.*,
    o_agg.num_orders,
    o_agg.total_spent,
    o_agg.last_order
FROM OPT_LAB_CLONE_1.RETAIL.CUSTOMERS AS c
LEFT JOIN (
    SELECT
        o.customer_id,
        COUNT(*)              AS num_orders,
        SUM(o.order_total)    AS total_spent,
        MAX(o.order_date)     AS last_order
    FROM OPT_LAB_CLONE_1.RETAIL.ORDERS AS o
    GROUP BY o.customer_id
) AS o_agg
    ON o_agg.customer_id = c.customer_id;