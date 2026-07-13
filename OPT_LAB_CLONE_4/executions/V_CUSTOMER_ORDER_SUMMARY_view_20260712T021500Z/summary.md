# Execution Summary

- **Execution ID:** exec-2026-07-13T02:15:00Z
- **Timestamp (payload):** 2026-07-12T02:15:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** SUCCESS

## Object
- **URN:** OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY
- **Type:** view
- **Task ID:** opt-1
- **Result:** SUCCESS

## What changed
- Refactored to use a single aggregated `LEFT JOIN` over `orders` (one grouped scan by `customer_id`).
- `total_spent` now defaults to `0` via `COALESCE(o_agg.total_spent, 0)` (previously could be `NULL` when no orders).
- Preserved semantics for `num_orders` defaulting to `0` and `last_order` remaining `NULL` when no orders.
