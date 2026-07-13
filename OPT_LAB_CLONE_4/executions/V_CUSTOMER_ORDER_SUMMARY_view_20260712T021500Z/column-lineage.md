# Column Lineage — V_CUSTOMER_ORDER_SUMMARY

| Output column | Expression | Upstream columns |
|---|---|---|
| `CUSTOMER_ID` | `c.customer_id` | `customers.customer_id` |
| `NUM_ORDERS` | `COALESCE(o_agg.num_orders, 0)` | `orders.customer_id` (group key) |
| `TOTAL_SPENT` | `COALESCE(o_agg.total_spent, 0)` | `orders.order_total`, `orders.customer_id` (group key) |
| `LAST_ORDER` | `o_agg.last_order` (`MAX(o.order_date)`) | `orders.order_date`, `orders.customer_id` (group key) |

Notes:
- Aggregations are computed in the derived table `o_agg` grouped by `o.customer_id`.
