create or replace view V_LOW_STOCK(
	INVENTORY_ID,
	WAREHOUSE_CODE,
	PRODUCT_ID,
	QTY_ON_HAND,
	REORDER_LEVEL,
	PRODUCT_NAME,
	SUPPLIER_NAME
) as
SELECT
    i.inventory_id,
    i.warehouse_code,
    i.product_id,
    i.qty_on_hand,
    i.reorder_level,
    (SELECT p.product_name FROM products p WHERE p.product_id = i.product_id) AS product_name,
    (SELECT s.supplier_name FROM suppliers s WHERE s.supplier_id = i.supplier_id) AS supplier_name
FROM inventory i
WHERE i.qty_on_hand < i.reorder_level;
