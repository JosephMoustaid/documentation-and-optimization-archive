# Column lineage (best-effort from SQL text)

## Previous view definition

| View column | Source expression | Source objects |
|---|---|---|
| CUSTOMER_ID | `c.customer_id` | `OPT_LAB_CLONE_4.RETAIL.customers c` |
| NUM_ORDERS | `COALESCE(o_agg.num_orders, 0)` | derived from `OPT_LAB_CLONE_4.RETAIL.orders o` (COUNT(*)) |
| TOTAL_SPENT | `o_agg.total_spent` | derived from `OPT_LAB_CLONE_4.RETAIL.orders o` (SUM(order_total)) |
| LAST_ORDER | `o_agg.last_order` | derived from `OPT_LAB_CLONE_4.RETAIL.orders o` (MAX(order_date)) |

## Optimized (attempted) SQL

| Output column / alias | Expression | Source |
|---|---|---|
| customer_id | `c.customer_id` | `CUSTOMERS c` |
| customer_name | `c.customer_name` | `CUSTOMERS c` (**invalid identifier**) |
| email | `c.email` | `CUSTOMERS c` |
| num_orders | `COUNT(o.order_id)` | `ORDERS o` |
| total_spent | `SUM(o.order_total)` | `ORDERS o` |
| last_order | `MAX(o.order_date)` | `ORDERS o` |
