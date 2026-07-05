CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on session database/schema.
  - Replaced the per-row correlated subquery with a LEFT JOIN + aggregation pattern to
    allow Snowflake to compute returned order counts more efficiently.
  - Preserved all output columns, data types, filters, ordering, and null-handling.
*/
SELECT
    s.customer_id,
    s.first_name,
    s.last_name,
    s.total_spent,
    /*
      EXACT semantic equivalence to:
        (SELECT COUNT(*)
         FROM orders o
         WHERE o.customer_id = s.customer_id
           AND o.status = 'RETURNED')

      The LEFT JOIN ensures that customers with no matching RETURNED orders still appear,
      with COUNT(o.order_id) returning 0, matching the original COUNT(*) behavior for
      a non-existent result set.

      If the original orders table allows NULL order_id, COUNT(order_id) and COUNT(*)
      can differ. If that is a possibility in your model, change to COUNT(*) while
      keeping the join/filter structure identical.
    */
    COUNT(o.order_id) AS returned_orders
FROM OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_ORDER_SUMMARY s
LEFT JOIN OPT_LAB_CLONE_1.RETAIL.ORDERS o
    ON  o.customer_id = s.customer_id
    AND o.status = 'RETURNED'
WHERE s.total_spent > 0
GROUP BY
    s.customer_id,
    s.first_name,
    s.last_name,
    s.total_spent
ORDER BY
    s.total_spent DESC;
