# Column lineage (best-effort)

Target: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

| Target column | Expression | Source columns |
|---|---|---|
| `customer_id` | `c.customer_id` | `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.customer_id` |
| `num_orders` | `COALESCE(o_agg.num_orders, 0)` where `o_agg.num_orders = COUNT(*)` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.customer_id` (group by) |
| `total_spent` | `o_agg.total_spent` where `o_agg.total_spent = SUM(o.order_total)` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.order_total` |
| `last_order` | `o_agg.last_order` where `o_agg.last_order = MAX(o.order_date)` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.order_date` |

Notes:
- `num_orders`, `total_spent`, and `last_order` are produced by an aggregated subquery grouped by `ORDERS.customer_id`.
