CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
    Optimizations / fixes:
    - Replaced invalid "c." with "c.*" to project all customer columns.
    - Replaced three correlated scalar subqueries with a single set-based
      aggregation over ORDERS grouped by CUSTOMER_ID.
    - Joined aggregated orders back to CUSTOMERS using a LEFT JOIN to
      preserve customers with no orders.
    - Fully qualified base table references for stable name resolution.
*/
SELECT
    c.*,
    o_agg.num_orders,
    o_agg.total_spent,
    o_agg.last_order
FROM OPT_LAB_CLONE_3.RETAIL.customers AS c
LEFT JOIN (
    SELECT
        o.customer_id,
        COUNT(*)           AS num_orders,
        SUM(o.order_total) AS total_spent,
        MAX(o.order_date)  AS last_order
    FROM OPT_LAB_CLONE_3.RETAIL.orders AS o
    GROUP BY
        o.customer_id
) AS o_agg
    ON o_agg.customer_id = c.customer_id;
