CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_LOW_STOCK AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references for stability across sessions.
  - Replaced scalar subqueries with LEFT JOINs to avoid per-row subquery execution
    while preserving behavior when product/supplier lookups are missing.
  - LEFT JOIN (not INNER) ensures rows are preserved even if dimension records
    are absent, matching original correlated subquery semantics.
  - Note: For performance, consider clustering/secondary indexes on
    INVENTORY(product_id, supplier_id), PRODUCTS(product_id), SUPPLIERS(supplier_id).
*/
SELECT
    i.inventory_id,
    i.warehouse_code,
    i.product_id,
    i.qty_on_hand,
    i.reorder_level,
    p.product_name,
    s.supplier_name
FROM OPT_LAB_CLONE_2.RETAIL.INVENTORY AS i
    LEFT JOIN OPT_LAB_CLONE_2.RETAIL.PRODUCTS AS p
        ON p.product_id = i.product_id
    LEFT JOIN OPT_LAB_CLONE_2.RETAIL.SUPPLIERS AS s
        ON s.supplier_id = i.supplier_id
WHERE i.qty_on_hand < i.reorder_level;
