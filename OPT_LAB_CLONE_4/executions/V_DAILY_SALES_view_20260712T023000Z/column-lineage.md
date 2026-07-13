# Column lineage — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

> Best-effort mapping from the optimized SQL.

| Output column | Expression | Source columns |
|---|---|---|
| ORDER_DATE | `o.order_date` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.order_date` |
| DAILY_TOTAL | `SUM(o.order_total)` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.order_total` |
| RUNNING_TOTAL | `SUM(SUM(o.order_total)) OVER (ORDER BY o.order_date ...)` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.order_total`, `OPT_LAB_CLONE_4.RETAIL.ORDERS.order_date` |
