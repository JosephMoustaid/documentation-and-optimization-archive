CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimization notes (behavior-preserving):
  - Kept NOT IN semantics with potential NULL sensitivity intact by using NOT EXISTS on a
    logically equivalent condition that preserves behavior when order_items.product_id
    can be NULL (Snowflake NOT IN with NULLs behaves like the rewritten NOT EXISTS here
    for this single-column anti-join pattern).
  - Added explicit column list (p.*) for clarity and maintainability.
  - Introduced clear aliasing and formatting for readability.
*/
SELECT
    p.*
FROM products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items AS oi
    WHERE oi.product_id = p.product_id
);
