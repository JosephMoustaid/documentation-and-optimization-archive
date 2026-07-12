# Summary — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

- **Object:** `OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES` (view)
- **Execution:** `exec-2026-07-11T17:45:00Z` (DRY_RUN)
- **Status:** VALIDATED (DDL validated via EXPLAIN; no changes applied)

## What the view does
Produces daily sales totals and a running total over time.

## Key change
Replaced a correlated subquery used to compute the running total with a window function over the aggregated daily totals.

## Primary benefit
Reduces repeated scans/work from the correlated subquery; typically improves performance and scalability as data grows.
