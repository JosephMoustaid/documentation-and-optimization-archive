CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimizations (behavior-preserving):
  - Removed DISTINCT and window functions in favor of a grouped aggregation,
    which is semantically equivalent because all non-aggregated columns are
    functionally dependent on supplier_id via the join.
  - Fully qualified base tables (OPT_LAB_CLONE_1.RETAIL.SUPPLIERS, OPT_LAB_CLONE_1.RETAIL.INVENTORY)
    for stable name resolution.
  - COUNT(i.inventory_id) and AVG(i.qty_on_hand) are computed per supplier using GROUP BY,
    preserving NULL handling and row-level results when one row per supplier is desired.
*/
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    COUNT(i.inventory_id) AS sku_count,
    AVG(i.qty_on_hand) AS avg_stock
FROM OPT_LAB_CLONE_1.RETAIL.SUPPLIERS AS s
LEFT JOIN OPT_LAB_CLONE_1.RETAIL.INVENTORY AS i
    ON i.supplier_id = s.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country;
