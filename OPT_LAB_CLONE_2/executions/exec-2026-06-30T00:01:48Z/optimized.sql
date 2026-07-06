CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on search path.
  - Removed unnecessary DISTINCT by rewriting window aggregates as grouped aggregates,
    preserving exact results while simplifying execution.
  - Explicitly qualified columns for clarity and maintainability.
*/
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    COUNT(i.inventory_id) AS sku_count,
    AVG(i.qty_on_hand)   AS avg_stock
FROM OPT_LAB_CLONE_2.RETAIL.SUPPLIERS AS s
LEFT JOIN OPT_LAB_CLONE_2.RETAIL.INVENTORY AS i
    ON i.supplier_id = s.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country;