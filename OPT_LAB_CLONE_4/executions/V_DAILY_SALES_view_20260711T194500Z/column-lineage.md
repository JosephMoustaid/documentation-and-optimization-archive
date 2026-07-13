# Column Lineage — `OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES`

| Output column | Derivation | Source columns |
|---|---|---|
| `ORDER_DATE` | passthrough | `ORDERS.ORDER_DATE` |
| `DAILY_TOTAL` | `SUM(d1.order_total)` grouped by `d1.order_date` | `ORDERS.ORDER_TOTAL` |
| `RUNNING_TOTAL` | `SUM(SUM(d1.order_total)) OVER (ORDER BY d1.order_date ...)` | `ORDERS.ORDER_TOTAL`, `ORDERS.ORDER_DATE` |
