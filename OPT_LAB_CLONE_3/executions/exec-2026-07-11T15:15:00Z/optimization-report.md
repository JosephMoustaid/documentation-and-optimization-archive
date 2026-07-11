# Optimization Report — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

## Status
- **Validation:** VALIDATED (EXPLAIN) in **DRY_RUN** mode
- **Applied:** No (dry run)

## Original pattern
The original view computed `RUNNING_TOTAL` using a correlated subquery:

```sql
(SELECT SUM(d2.order_total)
   FROM orders d2
  WHERE d2.order_date <= d1.order_date)
```

This can lead to repeated scans of `ORDERS` (one per outer row/date) and poor scaling.

## Changes made
Replaced the correlated subquery with a window function over the grouped daily totals:

```sql
SUM(SUM(d.order_total)) OVER (
  ORDER BY d.order_date
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

Also fully-qualified the base table reference:
- `OPT_LAB_CLONE_3.RETAIL.ORDERS`

## Expected benefits
- Single-pass aggregation + windowing instead of per-row correlated subquery execution
- Better optimization potential for the Snowflake planner (reduced work, improved runtime at scale)
