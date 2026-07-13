# Optimization Report — `OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES`

## Status
- **Result:** SUCCESS
- **Applied:** Yes (execution_mode=APPLY)

## Main optimization
### Before
Used a correlated subquery to compute `RUNNING_TOTAL`:

```sql
(SELECT SUM(d2.order_total)
   FROM orders d2
  WHERE d2.order_date <= d1.order_date)
```

### After
Uses a window function over the daily aggregate:

```sql
SUM(SUM(d1.order_total)) OVER (
  ORDER BY d1.order_date
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

## Why this is better
- Avoids executing a subquery per output row.
- Enables the optimizer to compute the running total in a single pass after aggregation.
- Typically reduces compute and improves scalability as data volume grows.

## Functional equivalence considerations
- Assumes `ORDER_DATE` granularity aligns between the two approaches.
- If there can be multiple rows per day, the optimized query aggregates per day first (same as original due to `GROUP BY d1.order_date`).

## Recommended follow-ups
- Ensure `ORDERS.ORDER_DATE` has an appropriate clustering / pruning strategy if the table is large.
