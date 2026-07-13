# Schema — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

> Derived from the view definition (types not available in payload).

| Column | Source / Derivation |
|---|---|
| `CUSTOMER_ID` | `customers.customer_id` |
| `NUM_ORDERS` | `COALESCE(o_agg.num_orders, 0)` where `o_agg.num_orders = COUNT(*)` grouped by `orders.customer_id` |
| `TOTAL_SPENT` | **Optimized:** `COALESCE(o_agg.total_spent, 0)` where `o_agg.total_spent = SUM(orders.order_total)` |
| `LAST_ORDER` | `o_agg.last_order = MAX(orders.order_date)` |
