# Summary — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

- **Execution ID:** exec-2026-07-12T02:30:00Z
- **Object:** OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES
- **Type:** view
- **Status:** SUCCESS
- **Warehouse:** ADF_WH

## What changed
The view was rewritten to compute **daily_total** and **running_total** in a single grouped query.

### Key improvement
- Removed the extra subquery level and reused the grouped aggregate inside the window function using `SUM(SUM(o.order_total)) OVER (...)`.

## Result
`V_DAILY_SALES` now aggregates from `OPT_LAB_CLONE_4.RETAIL.ORDERS` once per day and computes the running total over those daily aggregates.
