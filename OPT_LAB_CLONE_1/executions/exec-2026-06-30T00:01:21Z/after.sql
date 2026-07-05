CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimizations (behavior-preserving):
  - Removed DISTINCT by pre-aggregating at (supplier_id, supplier_name, country)
    level and using standard aggregates instead of window functions.
  - This preserves exact behavior because COUNT/AVG windows were partitioned
    only by supplier_id and DISTINCT eliminated duplicate rows; aggregating
    by supplier_id (+ attributes) yields one row per supplier with identical
    sku_count and avg_stock.
  - Fully qualified SUPPLIERS and INVENTORY tables to avoid dependency on
    current schema.
*/
WITH supplier_inventory AS (
    SELECT
        s.supplier_id,
        s.supplier_name,
        s.country,
        i.inventory_id,
        i.qty_on_hand
    FROM OPT_LAB_CLONE_1.RETAIL.SUPPLIERS AS s
    LEFT JOIN OPT_LAB_CLONE_1.RETAIL.INVENTORY AS i
        ON i.supplier_id = s.supplier_id
)
SELECT
    si.supplier_id,
    si.supplier_name,
    si.country,
    /*
      Equivalent to COUNT(i.inventory_id) OVER (PARTITION BY s.supplier_id)
      with DISTINCT removed by aggregating per supplier.
    */
    COUNT(si.inventory_id) AS sku_count,
    /*
      Equivalent to AVG(i.qty_on_hand) OVER (PARTITION BY s.supplier_id).
      AVG ignores NULLs, so behavior is preserved.
    */
    AVG(si.qty_on_hand) AS avg_stock
FROM supplier_inventory AS si
GROUP BY
    si.supplier_id,
    si.supplier_name,
    si.country;
