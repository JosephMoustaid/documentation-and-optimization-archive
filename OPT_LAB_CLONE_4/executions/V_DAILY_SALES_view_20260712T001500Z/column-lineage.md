# Column Lineage (inferred) — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

> Inferred from SQL only.

| Target column | Expression | Source columns |
|---|---|---|
| `ORDER_DATE` | `orders.order_date` | `ORDERS.ORDER_DATE` |
| `DAILY_TOTAL` | `SUM(orders.order_total)` | `ORDERS.ORDER_TOTAL` |
| `RUNNING_TOTAL` | Running sum over ordered `order_date` of daily totals | `ORDERS.ORDER_TOTAL`, `ORDERS.ORDER_DATE` |

## Correct running-total pattern

```sql
WITH daily AS (
  SELECT order_date, SUM(order_total) AS daily_total
  FROM OPT_LAB_CLONE_4.RETAIL.orders
  GROUP BY order_date
)
SELECT
  order_date,
  daily_total,
  SUM(daily_total) OVER (ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM daily;
```
