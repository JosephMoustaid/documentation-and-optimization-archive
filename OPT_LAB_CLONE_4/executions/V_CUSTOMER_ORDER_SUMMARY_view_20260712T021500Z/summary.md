# Optimization Summary — V_CUSTOMER_ORDER_SUMMARY

- **Database:** OPT_LAB_CLONE_4
- **Schema:** RETAIL
- **Object:** V_CUSTOMER_ORDER_SUMMARY (view)
- **Execution ID:** exec-2026-07-12T02:15:00Z
- **Timestamp:** 2026-07-12T02:15:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** SUCCESS

## What changed
- Kept the same logical approach (customers LEFT JOIN aggregated orders).
- **Behavioral tweak:** `total_spent` now defaults to **0** when a customer has no orders (was **NULL**).

## Resulting semantics
One row per customer:
- `num_orders`: count of orders (0 if none)
- `total_spent`: sum of `order_total` (0 if none)
- `last_order`: most recent `order_date` (NULL if none)
