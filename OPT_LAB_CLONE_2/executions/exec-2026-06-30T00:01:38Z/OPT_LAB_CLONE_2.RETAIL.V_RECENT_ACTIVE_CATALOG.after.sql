CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on session defaults.
  - Preserved use of UPPER and YEAR on columns to maintain exact semantics,
    including case-insensitive comparison and calendar-year filtering tied
    to CURRENT_DATE.
  - Explicit TRUE comparison retained for clarity and behavior equivalence.
  - No additional predicates or structural changes introduced that could
    alter result sets, ordering, or null-handling behavior.
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
