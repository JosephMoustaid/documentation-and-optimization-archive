# Schema — `OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES`

Derived from the view definition.

## Columns
- `ORDER_DATE` — date (inferred)
- `DAILY_TOTAL` — numeric (inferred; `SUM(order_total)`)
- `RUNNING_TOTAL` — numeric (inferred; running sum of `DAILY_TOTAL`)

## Base objects referenced
- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (aliased as `d1`)

> Note: Data types are inferred because source table DDL was not provided.
