# Optimization Report — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

- **Execution ID:** exec-2026-07-11T14:30:00Z
- **Mode:** DRY_RUN (validated via EXPLAIN; no changes applied)
- **Status:** VALIDATED

## Before

The prior view computed a running total using a correlated subquery:

- `running_total = (SELECT SUM(d2.order_total) FROM orders d2 WHERE d2.order_date <= d1.order_date)`

This pattern typically scales poorly because it can re-scan the base table per grouped date.

## After (candidate DDL)

The optimized candidate:

1. Aggregates daily totals once (`SUM(order_total)` grouped by `order_date`).
2. Computes the running total using a window function:
   - `SUM(daily_total) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`

## Expected impact

- Reduced repeated scanning by replacing the correlated subquery with a window aggregation.
- More predictable performance and improved optimizer opportunities.

## Notes

- The candidate DDL is fully qualified to `OPT_LAB_CLONE_3.RETAIL`.
- Output columns preserved: `ORDER_DATE`, `DAILY_TOTAL`, `RUNNING_TOTAL`.
