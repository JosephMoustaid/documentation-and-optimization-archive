CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE AS
SELECT DISTINCT
 s.supplier_id,
 s.supplier_name,
 s.country,
 COUNT(i.inventory_id) OVER (PARTITION BY s.supplier_id) AS sku_count,
 AVG(i.qty_on_hand) OVER (PARTITION BY s.supplier_id) AS avg_stock
FROM suppliers s
LEFT JOIN inventory i ON i.supplier_id = s.supplier_id;
