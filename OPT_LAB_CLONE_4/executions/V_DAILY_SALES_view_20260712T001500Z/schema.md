# Schema (inferred) — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

> Note: This schema is inferred from SQL text only (no live database introspection).

## View: `OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES`

| Column | Type | Description |
|---|---|---|
| `ORDER_DATE` | DATE / TIMESTAMP | Order date (grouping grain: day) |
| `DAILY_TOTAL` | NUMBER | Sum of `orders.order_total` per `order_date` |
| `RUNNING_TOTAL` | NUMBER | Running sum of daily totals ordered by `order_date` |

## Source table(s)

### `OPT_LAB_CLONE_4.RETAIL.ORDERS`

| Column | Type | Used for |
|---|---|---|
| `ORDER_DATE` | DATE / TIMESTAMP | Grouping and ordering |
| `ORDER_TOTAL` | NUMBER | Aggregation |
