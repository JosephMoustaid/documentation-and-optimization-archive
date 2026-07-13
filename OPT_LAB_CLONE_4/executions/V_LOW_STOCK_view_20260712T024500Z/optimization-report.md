# Optimization report — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

## Execution
- **Execution ID:** exec-2026-07-12T02:45:00Z
- **Timestamp:** 2026-07-12T02:45:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** SUCCESS

## Summary of change
**Before:**
- Selected `product_name` and `supplier_name` using two scalar subqueries correlated on `inventory`.
- Referenced lookup tables without full qualification (e.g., `products`, `suppliers`).

**After:**
- Replaced scalar subqueries with `LEFT JOIN` to `OPT_LAB_CLONE_4.RETAIL.products` and `OPT_LAB_CLONE_4.RETAIL.suppliers`.
- Fully qualified all referenced tables.

## Expected impact
- Reduces per-row work by eliminating repeated scalar subquery evaluations.
- Improves optimizer visibility into join relationships.

## Semantic considerations
- `LEFT JOIN` maintains the same row-preservation behavior as scalar subqueries in typical cases; if multiple matches exist in `products`/`suppliers`, joins can multiply rows. Ensure lookup tables are unique on their keys (`product_id`, `supplier_id`).
- Filter condition is unchanged: `qty_on_hand < reorder_level`.
