# Summary — V_CUSTOMER_ORDER_SUMMARY

**Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY` (view)  
**Execution:** `exec-2026-07-12T02:15:00Z`  
**Status:** SUCCESS

## What changed

- Preserved a single aggregated `LEFT JOIN` over `orders`.
- Standardized defaults using `COALESCE`:
  - `num_orders`: `COALESCE(..., 0)`
  - `total_spent`: `COALESCE(..., 0)` (changed from NULL when no orders)
- Kept `last_order` as `NULL` when no orders for semantic clarity.

## Expected impact

- No correlated subqueries; one grouped pass over `orders`.
- Clearer null/zero semantics for downstream consumption.
