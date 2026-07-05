-- Manual apply script for execution exec-2026-06-30T00:01:09Z
-- Status: FAILED (execution not performed in this run context)

CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS AS
/*
  Optimizations (behavior-preserving):
  - Replaced non-standard COUNT() with COUNT(*) in the scalar subquery.
    This is the standard and most efficient form and is required syntax
    in Snowflake, while remaining semantically identical for counting rows.
  - Fully qualified base objects for clarity and to avoid resolution
    ambiguities.
  - Preserved ORDER BY clause in the view definition to maintain the
    original observable ordering behavior.
*/
SELECT
    s.customer_id,
    s.first_name,
    s.last_name,
    s.total_spent,
    (
        SELECT COUNT(*)
        FROM OPT_LAB_CLONE_1.RETAIL.orders AS o
        WHERE o.customer_id = s.customer_id
          AND o.status = 'RETURNED'
    ) AS returned_orders
FROM OPT_LAB_CLONE_1.RETAIL.v_customer_order_summary AS s
WHERE s.total_spent > 0
ORDER BY s.total_spent DESC;
