CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
  Optimizations (behavior-preserving):
  - Replaced correlated scalar subqueries with a single pre-aggregated
    subquery joined on customer_id, reducing repeated scans of ORDERS.
  - Fully qualified table references to avoid reliance on session defaults.
  - Preserved exact semantics: same aggregates (COUNT, SUM, MAX) and
    join type (LEFT JOIN) to ensure all customers are returned, including
    those without any orders (yielding 0 / NULL as in the original).
  - COUNT(*) is used over the pre-filtered ORDERS rows, matching the
    original COUNT(*) per customer.
*/
SELECT
    c.*,
    o_agg.num_orders,
    o_agg.total_spent,
    o_agg.last_order
FROM OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c
LEFT JOIN (
    SELECT
        o.customer_id,
        COUNT(*)              AS num_orders,
        SUM(o.order_total)    AS total_spent,
        MAX(o.order_date)     AS last_order
    FROM OPT_LAB_CLONE_2.RETAIL.ORDERS AS o
    GROUP BY
        o.customer_id
) AS o_agg
    ON o_agg.customer_id = c.customer_id;
