CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid dependency on current schema search path.
  - Added explicit table aliases for clarity and maintainability.
  - Preserved UPPER() on category and YEAR() on last_restocked to ensure identical filtering semantics.
  - Kept boolean predicate form (p.active_flag = TRUE) to match original behavior exactly.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_1.RETAIL.PRODUCTS   AS p
JOIN OPT_LAB_CLONE_1.RETAIL.INVENTORY  AS i
    ON i.product_id = p.product_id
WHERE UPPER(p.category) = 'ELECTRONICS'                -- function on column (preserved)
  AND YEAR(i.last_restocked) = YEAR(CURRENT_DATE)      -- function on column (preserved)
  AND p.active_flag = TRUE;
