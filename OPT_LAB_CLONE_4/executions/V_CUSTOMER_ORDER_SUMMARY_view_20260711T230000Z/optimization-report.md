# Optimization Report

- **Execution ID:** exec-2026-07-11T23:00:00Z
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Type:** view
- **Mode:** APPLY
- **Result:** FAILED

## Intent of optimization

The optimized SQL attempted to implement the view via a single join between `CUSTOMERS` and `ORDERS` and then compute:

- `num_orders` via `COUNT(o.order_id)`
- `total_spent` via `SUM(o.order_total)`
- `last_order` via `MAX(o.order_date)`

This approach is logically equivalent to an aggregated subquery pattern when grouping keys match.

## Failure

**Compilation error:** `SQL compilation error: error line 4 at position 4 invalid identifier 'C.CUSTOMER_NAME'`

### Root cause

The optimized SQL referenced `c.customer_name` (and grouped by it). The `CUSTOMERS` table in `OPT_LAB_CLONE_4.RETAIL` does not have a column named `CUSTOMER_NAME`.

### Resolution

Regenerate or edit the optimized SQL to include only valid `CUSTOMERS` columns in the `SELECT` and `GROUP BY` lists. Keep the aggregation/join strategy unchanged to avoid altering semantics.

## Artifacts

- `previous.sql`: definition prior to optimization
- `optimized.sql`: SQL executed in APPLY mode (failed)
- `execution.json`: full execution payload including error message