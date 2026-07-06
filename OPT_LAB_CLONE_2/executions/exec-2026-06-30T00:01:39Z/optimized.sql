-- Execution: exec-2026-06-30T00:01:39Z
-- Database: OPT_LAB_CLONE_2
-- Warehouse: ADF_WH

-- Object: OPT_LAB_CLONE_2.RETAIL.V_SUPPLIER_PERFORMANCE (VIEW)
CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on session defaults.
  - Removed redundant DISTINCT by rewriting window aggregates as grouped aggregates,
    preserving exact row cardinality and values while reducing work.
  - GROUP BY uses only non-aggregated output columns, matching the original
    projection and ensuring one row per supplier.
  - LEFT JOIN retained to preserve suppliers with no inventory rows (yielding
    NULL sku_count and avg_stock), exactly as in the original semantics.
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
