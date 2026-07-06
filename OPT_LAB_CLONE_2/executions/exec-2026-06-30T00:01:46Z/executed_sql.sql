CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on search path.
  - Replaced NOT IN (subquery) with NOT EXISTS to avoid NULL-related
    anti-join semantics changes and to improve performance in Snowflake.
  - Selected explicit columns instead of "SELECT p.*" for clarity and
    maintainability.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM OPT_LAB_CLONE_2.RETAIL.PRODUCTS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_2.RETAIL.ORDER_ITEMS oi
    WHERE oi.product_id = p.product_id
);
