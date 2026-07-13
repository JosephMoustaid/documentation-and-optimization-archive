# Column Lineage — V_CUSTOMER_ORDER_SUMMARY

| Output column | Expression | Upstream columns |
|---|---|---|
| CUSTOMER_ID | `c.customer_id` | `customers.customer_id` |
| NUM_ORDERS | `COALESCE(o_agg.num_orders, 0)` where `o_agg.num_orders = COUNT(*)` | `orders.customer_id` |
| TOTAL_SPENT | `COALESCE(o_agg.total_spent, 0)` where `o_agg.total_spent = SUM(o.order_total)` | `orders.order_total`, `orders.customer_id` |
| LAST_ORDER | `o_agg.last_order` where `o_agg.last_order = MAX(o.order_date)` | `orders.order_date`, `orders.customer_id` |
