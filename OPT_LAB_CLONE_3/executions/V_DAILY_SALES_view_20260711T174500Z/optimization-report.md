# Optimization report — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

## Execution
- **Execution id:** `exec-2026-07-11T17:45:00Z`
- **Mode:** `DRY_RUN`
- **Warehouse:** `ADF_WH`
- **Status:** VALIDATED (validated via EXPLAIN)

## Before (previous.sql)
- Computed `RUNNING_TOTAL` using a correlated subquery:
  - For each `ORDER_DATE` in the grouped result, it re-summed `ORDERS` up to that date.

## After (optimized.sql)
- Computes `DAILY_TOTAL` once (aggregate by `ORDER_DATE`).
- Computes `RUNNING_TOTAL` using a window function:
  - `SUM(DAILY_TOTAL) OVER (ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`

## Why this is better
- Avoids repeated work implied by the correlated subquery.
- Enables the optimizer to execute the cumulative computation as a single pass over the aggregated result.

## Notes / validation
- This run did not apply changes (DRY_RUN). Review `optimized.sql` and apply manually if desired.
