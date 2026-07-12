# Column lineage — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

| Output column | Derived from | Notes |
|---|---|---|
| `ORDER_DATE` | `OPT_LAB_CLONE_3.RETAIL.ORDERS.ORDER_DATE` | Grouping key and window ordering key. |
| `DAILY_TOTAL` | `SUM(OPT_LAB_CLONE_3.RETAIL.ORDERS.ORDER_TOTAL)` | Aggregated per `ORDER_DATE`. |
| `RUNNING_TOTAL` | `SUM(DAILY_TOTAL) OVER (ORDER BY ORDER_DATE …)` | Window function over aggregated daily totals. |
