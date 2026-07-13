CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_4.RETAIL.products   AS p
JOIN OPT_LAB_CLONE_4.RETAIL.inventory  AS i
    ON i.product_id = p.product_id
WHERE
    -- Category filter (case-insensitive). If data is cleanly cased, this can be simplified.
    UPPER(p.category) = 'ELECTRONICS'
    -- Current-year restock using range predicates instead of YEAR() on the column.
    AND i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)
    AND i.last_restocked <  DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)
    -- Explicit active flag filter
    AND p.active_flag = TRUE;
