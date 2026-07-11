# Optimization Report — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

- **Execution:** `exec-2026-07-11T12:45:00Z`
- **Mode:** `DRY_RUN`
- **Status:** `VALIDATED` (via `EXPLAIN`)
- **Applied:** No

## Before

The view computed `RUNNING_TOTAL` using a correlated subquery:

```sql
(SELECT SUM(d2.order_total)
   FROM orders d2
  WHERE d2.order_date <= d1.order_date)
```

This can cause repeated scans/aggregation and typically scales poorly as data grows.

## After

The optimized definition replaces the correlated subquery with a window function over daily aggregates:

```sql
SUM(daily_total) OVER (
  ORDER BY order_date
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

This pattern is generally more efficient and clearer.

## Notes

- In this execution the SQL was **validated only** (DRY_RUN). The underlying view was not modified.
- The optimized SQL references `OPT_LAB_CLONE_3.RETAIL.ORDERS` explicitly.
