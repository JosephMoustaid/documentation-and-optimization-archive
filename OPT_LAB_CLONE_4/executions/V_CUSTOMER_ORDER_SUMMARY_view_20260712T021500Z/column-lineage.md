# Column lineage — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

| Output column | Expression | Source columns |
|---|---|---|
| CUSTOMER_ID | `c.customer_id` | `customers.customer_id` |
| NUM_ORDERS | `COALESCE(o_agg.num_orders, 0)` | `orders.customer_id` (group key), derived `COUNT(*)` |
| TOTAL_SPENT | `COALESCE(o_agg.total_spent, 0)` | `orders.order_total` (SUM) |
| LAST_ORDER | `o_agg.last_order` | `orders.order_date` (MAX) |
