# Schema — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

> Best-effort schema inferred from SQL text.

## Output columns
| Column | Type | Notes |
|---|---|---|
| ORDER_DATE | (unknown) | Derived from `orders.order_date` |
| DAILY_TOTAL | (unknown) | `SUM(orders.order_total)` grouped by date |
| RUNNING_TOTAL | (unknown) | Running sum over daily totals |

## Source objects
- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias: `o`)

## Grouping / windowing
- `GROUP BY o.order_date`
- Window: `SUM(SUM(o.order_total)) OVER (ORDER BY o.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`
