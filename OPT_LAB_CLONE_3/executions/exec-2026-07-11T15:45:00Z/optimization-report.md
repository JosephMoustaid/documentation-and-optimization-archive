# Optimization Report — OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Execution

- **Execution ID:** exec-2026-07-11T15:45:00Z
- **Mode:** DRY_RUN
- **Validation:** EXPLAIN
- **Applied:** No (DRY_RUN)
- **Status:** VALIDATED

## What changed (proposed)

### Before
- Selected `c.*` from `CUSTOMERS`.
- Used **three correlated scalar subqueries** against `ORDERS` per customer:
  - `COUNT(*)`
  - `SUM(order_total)`
  - `MAX(order_date)`

### After (optimized definition)
- Replaced correlated subqueries with a **single aggregated subquery** grouped by `customer_id`.
- Joined the aggregate results back to `CUSTOMERS` via `LEFT JOIN`.
- Made customer columns explicit (instead of `c.*`) to reduce scan width and improve schema stability.
- Added `COALESCE` for numeric aggregates so customers with zero orders yield `0`.

## Expected benefits

- Avoid repeated scans / per-row subquery evaluation of `ORDERS`.
- Better optimizer plan opportunities (aggregation + join).
- More stable view definition over time.

## Notes

This optimization was validated via `EXPLAIN` only. **No DDL was executed** against `OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY`.
