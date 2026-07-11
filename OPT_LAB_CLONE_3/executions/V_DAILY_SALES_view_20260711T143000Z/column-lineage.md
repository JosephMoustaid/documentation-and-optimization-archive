# Column Lineage — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

| Target column | Source expression / lineage |
|---|---|
| `ORDER_DATE` | `orders.order_date` |
| `DAILY_TOTAL` | `SUM(orders.order_total)` grouped by `orders.order_date` |
| `RUNNING_TOTAL` | `SUM(daily_total) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` |
