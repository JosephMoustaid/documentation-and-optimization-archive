# Optimization report — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

## Outcome
- **Status:** SUCCESS
- **Applied:** Yes (execution_mode = APPLY)

## Previous pattern
The previous view used scalar subqueries in the SELECT list to fetch `product_name` and `supplier_name`:
- `(SELECT p.product_name FROM products p WHERE p.product_id = i.product_id)`
- `(SELECT s.supplier_name FROM suppliers s WHERE s.supplier_id = i.supplier_id)`

## Optimization applied
Rewrote the view using explicit joins:
- `LEFT JOIN OPT_LAB_CLONE_4.RETAIL.products  p ON p.product_id = i.product_id`
- `LEFT JOIN OPT_LAB_CLONE_4.RETAIL.suppliers s ON s.supplier_id = i.supplier_id`

## Why this helps
- Avoids per-row scalar subquery evaluation patterns.
- Gives the optimizer a clearer join graph for planning.
- Improves readability/maintainability.

## Semantics notes
- `LEFT JOIN` preserves rows from `inventory` even when no matching product/supplier exists (matching typical scalar-subquery behavior returning NULL when not found).
- Filter `i.qty_on_hand < i.reorder_level` remains unchanged.
