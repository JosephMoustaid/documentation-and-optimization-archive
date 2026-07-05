CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified references for both base view and orders table to avoid dependency on current schema.
  - Replaced scalar correlated subquery with a LEFT JOIN + grouped aggregation to allow better optimization
    (while preserving exact semantics, including NULL behavior when no matching orders exist).
  - Preserved ORDER BY clause in the view definition to maintain original ordering behavior.
*/
SELECT
    s.customer_id,
    s.first_name,
    s.last_name,
    s.total_spent,
    /*
      Original expression:
      (SELECT COUNT() FROM orders o
       WHERE o.customer_id = s.customer_id
         AND o.status = 'RETURNED') AS returned_orders

      New expression:
      COALESCE(SUM(o.is_returned), 0) AS returned_orders

      Implementation details:
      - We join to the ORDERS table and compute a derived column is_returned
        that is 1 when status = 'RETURNED', else 0.
      - SUM(is_returned) over the joined rows equals COUNT(*) with the same predicate.
      - LEFT JOIN + COALESCE ensures 0 when there are no matching orders, matching COUNT() behavior.
    */
    COALESCE(SUM(o.is_returned), 0) AS returned_orders
FROM OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS s
LEFT JOIN (
    SELECT
        o.customer_id,
        /*
          Using a CASE expression to derive a numeric flag for returned orders.
          This is semantically equivalent to filtering by status = 'RETURNED'
          in the original correlated subquery, when used with SUM.
        */
        CASE WHEN o.status = 'RETURNED' THEN 1 ELSE 0 END AS is_returned
    FROM OPT_LAB_CLONE_1.RETAIL.ORDERS AS o
) AS o
    ON o.customer_id = s.customer_id
WHERE s.total_spent > 0
GROUP BY
    s.customer_id,
    s.first_name,
    s.last_name,
    s.total_spent
ORDER BY
    s.total_spent DESC;
