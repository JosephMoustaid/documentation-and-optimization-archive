# Optimization Report — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

## Outcome

- **Execution mode:** APPLY
- **Status:** FAILED
- **Error:** `SQL compilation error: [D1.ORDER_TOTAL] is not a valid group by expression`

## What happened

The attempted optimized SQL computed:

- `daily_total = SUM(d1.order_total)` (aggregate)
- `running_total = SUM(d1.order_total) OVER (ORDER BY d1.order_date ...)` (window on base column)

while also using `GROUP BY d1.order_date`.

In Snowflake SQL, once you group, non-grouped base columns cannot be referenced directly in the SELECT list unless they are inside an aggregate that is compatible with the grouping context. A window function over `d1.order_total` in the same SELECT of a grouped query violates this rule.

## Recommended corrected definition

Use a two-step approach: aggregate first, then window over the aggregated results.

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES AS
WITH daily AS (
  SELECT
    o.order_date,
    SUM(o.order_total) AS daily_total
  FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
  GROUP BY o.order_date
)
SELECT
  order_date,
  daily_total,
  SUM(daily_total) OVER (
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM daily;
```

## Notes

- The **previous** definition already follows an equivalent valid pattern using `SUM(SUM(o.order_total)) OVER (...)`.
- Any "optimization" should preserve semantic correctness before applying stylistic changes.
