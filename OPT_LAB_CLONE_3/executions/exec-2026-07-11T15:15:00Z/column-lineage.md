# Column Lineage — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

Source: `OPT_LAB_CLONE_3.RETAIL.ORDERS` (aliased as `d`)

| Target column | Expression | Source columns |
|---|---|---|
| `ORDER_DATE` | `d.order_date` | `ORDERS.ORDER_DATE` |
| `DAILY_TOTAL` | `SUM(d.order_total)` | `ORDERS.ORDER_TOTAL` |
| `RUNNING_TOTAL` | `SUM(SUM(d.order_total)) OVER (ORDER BY d.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` | `ORDERS.ORDER_TOTAL`, `ORDERS.ORDER_DATE` |

Notes:
- `RUNNING_TOTAL` is computed as a running sum over daily aggregates (window over the grouped result).
