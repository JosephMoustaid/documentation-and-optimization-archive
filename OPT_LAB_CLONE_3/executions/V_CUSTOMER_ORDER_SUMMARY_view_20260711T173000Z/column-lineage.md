# Column lineage — V_CUSTOMER_ORDER_SUMMARY

**View:** `OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

## Pass-through columns
All columns from `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` are projected via `c.*` with 1:1 lineage.

## Derived columns
| Output column | Source columns | Derivation |
|---|---|---|
| `NUM_ORDERS` | `OPT_LAB_CLONE_3.RETAIL.ORDERS.CUSTOMER_ID` | `COUNT(*)` grouped by `customer_id`, then `COALESCE(...,0)` |
| `TOTAL_SPENT` | `OPT_LAB_CLONE_3.RETAIL.ORDERS.ORDER_TOTAL`, `OPT_LAB_CLONE_3.RETAIL.ORDERS.CUSTOMER_ID` | `SUM(order_total)` grouped by `customer_id`, then `COALESCE(...,0)` |
| `LAST_ORDER` | `OPT_LAB_CLONE_3.RETAIL.ORDERS.ORDER_DATE`, `OPT_LAB_CLONE_3.RETAIL.ORDERS.CUSTOMER_ID` | `MAX(order_date)` grouped by `customer_id` |
