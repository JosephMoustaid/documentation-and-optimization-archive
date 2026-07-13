# Summary — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

- **Execution ID:** exec-2026-07-12T02:15:00Z
- **Timestamp (UTC):** 2026-07-12T02:15:00Z
- **Warehouse:** ADF_WH
- **Execution mode:** APPLY
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY` (view)
- **Status:** SUCCESS

## What changed
- Uses a single aggregated `LEFT JOIN` over `orders` (one grouped pass per customer).
- Ensures `num_orders` defaults to `0` via `COALESCE`.
- Changes `total_spent` to `COALESCE(total_spent, 0)` (previously could be `NULL` when no orders).
- Keeps `last_order` as `NULL` when no orders.
