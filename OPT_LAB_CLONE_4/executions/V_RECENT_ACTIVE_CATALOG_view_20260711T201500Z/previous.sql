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
FROM products p
JOIN inventory i ON i.product_id = p.product_id
WHERE UPPER(p.category) = 'ELECTRONICS'                -- function on column
  AND YEAR(i.last_restocked) = YEAR(CURRENT_DATE)      -- function on column
  AND p.active_flag = TRUE;
