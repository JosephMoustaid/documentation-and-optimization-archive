# Schema (inferred)

## Output: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

| Column | Type | Notes |
|---|---|---|
| CUSTOMER_ID | unknown | From `customers.customer_id` |
| NUM_ORDERS | number | `COALESCE(COUNT(*), 0)` via aggregated join |
| TOTAL_SPENT | number | `COALESCE(SUM(order_total), 0)` |
| LAST_ORDER | datetime/date | `MAX(order_date)`; `NULL` when no orders |

## Inputs
- `OPT_LAB_CLONE_4.RETAIL.customers` (alias `c`)
- `OPT_LAB_CLONE_4.RETAIL.orders` (alias `o`, aggregated as `o_agg`)
