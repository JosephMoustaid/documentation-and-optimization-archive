CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK AS
SELECT
    i.inventory_id,
    i.warehouse_code,
    i.product_id,
    i.qty_on_hand,
    i.reorder_level,
    p.product_name,
    s.supplier_name
FROM OPT_LAB_CLONE_4.RETAIL.inventory AS i
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.products  AS p
    ON p.product_id = i.product_id
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.suppliers AS s
    ON s.supplier_id = i.supplier_id
WHERE i.qty_on_hand < i.reorder_level;
