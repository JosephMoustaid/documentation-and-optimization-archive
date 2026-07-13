# Summary — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

- **Execution ID:** exec-2026-07-12T02:45:00Z
- **Timestamp:** 2026-07-12T02:45:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Object:** OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK (view)
- **Status:** SUCCESS

## What changed
Replaced two correlated scalar subqueries (to `products` and `suppliers`) with `LEFT JOIN`s and fully qualified object references.

## Why it matters
- Avoids repeated subquery execution per row.
- Gives the optimizer a clearer join graph (often enabling better planning and pruning).
- Preserves original filter: `i.qty_on_hand < i.reorder_level`.
