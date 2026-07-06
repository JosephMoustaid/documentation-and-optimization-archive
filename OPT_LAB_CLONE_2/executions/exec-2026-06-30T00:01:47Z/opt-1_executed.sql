CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on search path.
  - Kept predicate forms (UPPER, YEAR) exactly as in original to
    preserve semantics and avoid any subtle behavior changes.
  - Explicitly qualified columns for clarity and maintainability.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_2.RETAIL.PRODUCTS AS p
JOIN OPT_LAB_CLONE_2.RETAIL.INVENTORY AS i
  ON i.product_id = p.product_id
WHERE UPPER(p.category) = 'ELECTRONICS'
  AND YEAR(i.last_restocked) = YEAR(CURRENT_DATE)
  AND p.active_flag = TRUE;
