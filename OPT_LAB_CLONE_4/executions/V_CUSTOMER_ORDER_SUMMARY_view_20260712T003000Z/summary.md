# Execution Summary

- **Execution ID:** exec-2026-07-12T00:30:00Z
- **Timestamp (UTC):** 2026-07-12T00:30:00Z
- **Warehouse:** ADF_WH
- **Execution mode:** APPLY
- **Overall status:** SUCCESS

## Object
- **URN:** OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY
- **Type:** view
- **Task ID:** opt-1
- **Status:** SUCCESS

## Outcome
The view was applied successfully. The definition uses a single aggregated `LEFT JOIN` over `orders` (with `COUNT(*)`, `SUM(order_total)`, `MAX(order_date)`) instead of multiple correlated subqueries.
