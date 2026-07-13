# Schema (referenced objects)

Object: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

Referenced tables/views (from SQL parsing, best-effort):
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (alias `c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias `o`, aggregated as `o_agg`)

Referenced columns (best-effort):
- From `CUSTOMERS` (`c`): `customer_id`
- From `ORDERS` (`o`): `customer_id`, `order_total`, `order_date`

Notes:
- `num_orders` is derived as `COUNT(*)` grouped by `o.customer_id`.
- `total_spent` is derived as `SUM(o.order_total)`.
- `last_order` is derived as `MAX(o.order_date)`.
