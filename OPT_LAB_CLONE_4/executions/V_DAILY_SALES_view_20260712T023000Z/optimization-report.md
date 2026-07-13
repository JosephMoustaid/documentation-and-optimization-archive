# Optimization report — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

- **Execution ID:** exec-2026-07-12T02:30:00Z
- **Object:** OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES
- **Type:** view
- **Status:** SUCCESS

## Before
The prior definition computed daily totals in a subquery and then computed the running total over that derived result.

## After
The optimized definition performs a single scan and aggregation over `OPT_LAB_CLONE_4.RETAIL.ORDERS`:
- `daily_total = SUM(o.order_total)` grouped by `o.order_date`
- `running_total = SUM(SUM(o.order_total)) OVER (ORDER BY o.order_date ...)`

## Why this is better
- **Less query nesting:** removes an unnecessary derived table.
- **Single aggregation pass:** computes the daily aggregate once and reuses it for the windowed running total.
- **Clearer intent:** one grouped query with a windowed aggregate over grouped results.

## Functional equivalence
The result set remains the same: one row per `order_date` with `daily_total` and cumulative `running_total` ordered by date.

## Risks / validation
- Ensure `order_date` has the intended granularity (date vs timestamp) for daily grouping.
- Confirm ordering semantics for ties (multiple identical `order_date` values) remain acceptable.
