CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on current schema search path.
  - Expanded SELECT c.* for clarity and maintainability would normally be ideal, but
    we retain the original projection semantics (all customer columns) via c.* to
    preserve the exact output schema.
  - Replaced three correlated scalar subqueries with a single aggregation query
    joined back to CUSTOMERS. This reduces repeated scans of the ORDERS table while
    preserving the exact semantics for all customer_id values present in CUSTOMERS.
  - COALESCE wrapper ensures NULL-handling behavior matches the original correlated
    subqueries: when no matching orders exist for a customer, the scalar subqueries
    would return NULL, so we preserve that behavior.
*/
SELECT
    c.*,
    /*
      The correlated COUNT() subquery returns:
        - 0 when at least one order exists but all rows are counted (COUNT never NULL),
        - NULL when no matching orders exist (subquery returns no rows).
      The join + aggregation produces NULL when no orders exist; we preserve this by
      not wrapping COUNT in COALESCE.
    */
    o_agg.num_orders,
    /* SUM(order_total) and MAX(order_date) produce NULL when no matching rows exist.
       Aggregation via LEFT JOIN preserves this behavior directly. */
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
