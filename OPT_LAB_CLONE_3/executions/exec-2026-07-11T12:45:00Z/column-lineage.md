# Column Lineage — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

Source: `OPT_LAB_CLONE_3.RETAIL.ORDERS` (alias `o`)

| Target column | Derivation | Source columns |
|---|---|---|
| `ORDER_DATE` | `o.ORDER_DATE` | `ORDERS.ORDER_DATE` |
| `DAILY_TOTAL` | `SUM(o.ORDER_TOTAL)` grouped by `o.ORDER_DATE` | `ORDERS.ORDER_TOTAL` |
| `RUNNING_TOTAL` | `SUM(daily_total) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` | derived from `DAILY_TOTAL` |
