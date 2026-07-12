# Schema — OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES

Inferred output columns (types not available from the input payload):

| Column | Description |
|---|---|
| `ORDER_DATE` | Order date used for grouping and ordering the running total. |
| `DAILY_TOTAL` | Sum of `ORDERS.ORDER_TOTAL` for the day. |
| `RUNNING_TOTAL` | Cumulative sum of `DAILY_TOTAL` ordered by `ORDER_DATE`. |
