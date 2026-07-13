create or replace view V_RECENT_ACTIVE_CATALOG(
	PRODUCT_ID,
	PRODUCT_NAME,
	CATEGORY,
	UNIT_PRICE
) as
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_4.RETAIL.products AS p
JOIN OPT_LAB_CLONE_4.RETAIL.inventory AS i
    ON i.product_id = p.product_id
WHERE
    -- Case-insensitive match without applying a function on the column
    p.category ILIKE 'electronics'
    -- Restrict to rows with last_restocked in the current calendar year
    AND i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)
    AND i.last_restocked <  DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)
    -- Preserve active_flag filter
    AND p.active_flag = TRUE;
