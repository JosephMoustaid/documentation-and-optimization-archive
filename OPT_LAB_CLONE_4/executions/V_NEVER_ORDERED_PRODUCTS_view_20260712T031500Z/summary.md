# Summary — V_NEVER_ORDERED_PRODUCTS

- **Object**: `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS` (view)
- **Execution ID**: `exec-2026-07-12T03:15:00Z`
- **Timestamp**: `2026-07-12T03:15:00Z`
- **Warehouse**: `ADF_WH`
- **Mode**: `APPLY`
- **Status**: SUCCESS

## What changed
- Preserved the `NOT EXISTS` anti-join pattern to return products that have no matching rows in `ORDER_ITEMS`.
- Standardized to fully-qualified references.
- Simplified projection to `p.*` to return all product columns.

## Notes
The previous definition appears incomplete (`SELECT p.`). The applied optimized definition compiles by selecting `p.*`.
