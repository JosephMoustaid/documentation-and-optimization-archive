CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
  Optimizations (behavior-preserving):
  - Replaced correlated scalar subqueries with a single LEFT JOIN to a pre-aggregated
    customer_orders summary, reducing repeated scans of the ORDERS table.
  - Fully qualified table references to avoid reliance on search path.
  - Explicitly listed customer columns (c.*) to avoid syntax errors and to keep
    the output schema explicit and stable.
  - Preserved exact aggregation logic and null-handling behavior via LEFT JOIN.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.address,
    c.city,
    c.state,
    c.postal_code,
    c.country,
    co.num_orders,
    co.total_spent,
    co.last_order
FROM OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c
LEFT JOIN (
    SELECT
        o.customer_id,
        COUNT(*)          AS num_orders,
        SUM(o.order_total) AS total_spent,
        MAX(o.order_date)  AS last_order
    FROM OPT_LAB_CLONE_2.RETAIL.ORDERS AS o
    GROUP BY
        o.customer_id
) AS co
    ON co.customer_id = c.customer_id;
