CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimization notes (behavior-preserving):
  - Replaced DISTINCT + window aggregates with a grouped subquery to
    compute per-supplier metrics, then joined back to suppliers.
  - This avoids redundant window computations over duplicated rows
    while preserving exact results and output schema.
*/
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    sp.sku_count,
    sp.avg_stock
FROM suppliers s
LEFT JOIN (
    SELECT
        i.supplier_id,
        COUNT(i.inventory_id) AS sku_count,
        AVG(i.qty_on_hand) AS avg_stock
    FROM inventory i
    GROUP BY i.supplier_id
) sp
    ON sp.supplier_id = s.supplier_id;
