CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references for clarity and to avoid dependency on current DB/Schema.
  - Replaced NOT IN (subquery) with NOT EXISTS for safer null-handling and typically better optimization.
  - Added explicit column list in SELECT for correctness and maintainability.
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