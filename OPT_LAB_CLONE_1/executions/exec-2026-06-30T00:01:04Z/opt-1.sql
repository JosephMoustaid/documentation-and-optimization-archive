CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimization notes (behavior-preserving):
  - Preserved CASE-SENSITIVE filter on category via UPPER(column) to ensure identical behavior.
  - Kept YEAR(i.last_restocked) = YEAR(CURRENT_DATE) to avoid changing date boundary semantics.
  - Added explicit, standardized aliasing for readability.
  - Left predicates structurally unchanged to guarantee identical results and null-handling.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM products  AS p
JOIN inventory AS i
    ON i.product_id = p.product_id
WHERE UPPER(p.category) = 'ELECTRONICS'
  AND YEAR(i.last_restocked) = YEAR(CURRENT_DATE)
  AND p.active_flag = TRUE;
