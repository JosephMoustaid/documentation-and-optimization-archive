# Schema — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

Inferred from the view column list and SELECT aliases.

| Column | Notes |
|---|---|
| CUSTOMER_ID | From `customers.customer_id` |
| NUM_ORDERS | `COALESCE(o_agg.num_orders, 0)` |
| TOTAL_SPENT | `COALESCE(o_agg.total_spent, 0)` |
| LAST_ORDER | `o_agg.last_order` (`MAX(order_date)`) |
