create or replace view V_NEVER_ORDERED_PRODUCTS(
	PRODUCT_ID,
	PRODUCT_NAME,
	CATEGORY,
	UNIT_PRICE,
	ACTIVE_FLAG
) as
SELECT
    p.*
FROM OPT_LAB_CLONE_4.RETAIL.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_4.RETAIL.order_items AS oi
    WHERE oi.product_id = p.product_id
);
