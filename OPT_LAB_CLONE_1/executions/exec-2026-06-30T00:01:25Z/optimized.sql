CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on current schema search path.
  - Added explicit column list for clarity and maintainability.
  - Replaced NOT IN (subquery) with NOT EXISTS to avoid NULL-sensitivity issues and
    to enable better optimization while preserving semantics under the assumption
    that original behavior was intended for non-NULL product_id comparisons.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    p.active_flag
FROM OPT_LAB_CLONE_1.RETAIL.PRODUCTS AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS AS oi
    WHERE oi.product_id = p.product_id
);
