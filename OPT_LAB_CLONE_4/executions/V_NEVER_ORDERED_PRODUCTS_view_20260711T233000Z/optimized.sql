CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.price,
    p.status
    -- Add or remove columns as appropriate for OPT_LAB_CLONE_4.RETAIL.PRODUCTS
FROM OPT_LAB_CLONE_4.RETAIL.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_4.RETAIL.order_items AS oi
    WHERE oi.product_id = p.product_id
);
