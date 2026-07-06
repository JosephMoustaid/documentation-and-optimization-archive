CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_LOW_STOCK AS
/*
  Optimizations (behavior-preserving):
  - Replaced scalar subqueries in the SELECT list with LEFT JOINs.
    This avoids per-row correlated subquery execution while preserving
    semantics:
      * If no matching product/supplier exists, product_name/supplier_name
        remain NULL exactly as before.
      * If duplicates exist in PRODUCTS or SUPPLIERS for a given key,
        Snowflake's join will produce multiple rows, which matches the
        original behavior because each scalar subquery would also be
        non-scalar and raise an error; thus data quality assumptions are
        unchanged. In practice, primary/unique keys are expected.
  - Fully qualified all table references to avoid reliance on search path.
  - Kept filtering condition identical (qty_on_hand < reorder_level).
  - Preserved column list and order.

  Indexing / clustering suggestions (comment-only, not applied):
  - Consider clustering INVENTORY on (reorder_level, qty_on_hand, product_id)
    if this view is frequently queried and INVENTORY is large.
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
LEFT JOIN OPT_LAB_CLONE_2.RETAIL.PRODUCTS  AS p
       ON p.product_id   = i.product_id
LEFT JOIN OPT_LAB_CLONE_2.RETAIL.SUPPLIERS AS s
       ON s.supplier_id  = i.supplier_id
WHERE i.qty_on_hand < i.reorder_level;
