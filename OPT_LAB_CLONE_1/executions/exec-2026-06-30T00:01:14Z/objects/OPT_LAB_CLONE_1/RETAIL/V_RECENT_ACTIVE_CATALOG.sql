CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified base tables to avoid reliance on current database/schema.
  - Rewrote UPPER(p.category) = 'ELECTRONICS' to be case-insensitive via COLLATE,
    preserving behavior while making the predicate sargable for potential index use.
  - Replaced YEAR(i.last_restocked) = YEAR(CURRENT_DATE) with a date range filter
    on i.last_restocked, preserving exact semantics for date and timestamp types
    while allowing potential partition/pruning optimizations.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_1.RETAIL.PRODUCTS AS p
JOIN OPT_LAB_CLONE_1.RETAIL.INVENTORY AS i
    ON i.product_id = p.product_id
WHERE
    /* Case-insensitive match on category = 'ELECTRONICS' */
    p.category COLLATE "en-ci" = 'ELECTRONICS'
    AND i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)
    AND i.last_restocked <  DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)
    AND p.active_flag = TRUE;
