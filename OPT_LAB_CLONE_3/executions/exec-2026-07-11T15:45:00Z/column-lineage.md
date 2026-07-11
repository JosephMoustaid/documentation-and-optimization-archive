# Column Lineage — OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY

| View column | Source expression | Source table(s) |
|---|---|---|
| CUSTOMER_ID | `c.customer_id` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| FIRST_NAME | `c.first_name` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| LAST_NAME | `c.last_name` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| EMAIL | `c.email` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| COUNTRY | `c.country` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| SIGNUP_DATE | `c.signup_date` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| IS_ACTIVE | `c.is_active` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| LIFETIME_VALUE | `c.lifetime_value` | OPT_LAB_CLONE_3.RETAIL.CUSTOMERS |
| NUM_ORDERS | `COALESCE(o_agg.num_orders, 0)` where `o_agg.num_orders = COUNT(*)` | OPT_LAB_CLONE_3.RETAIL.ORDERS |
| TOTAL_SPENT | `COALESCE(o_agg.total_spent, 0)` where `o_agg.total_spent = SUM(o.order_total)` | OPT_LAB_CLONE_3.RETAIL.ORDERS |
| LAST_ORDER | `o_agg.last_order` where `o_agg.last_order = MAX(o.order_date)` | OPT_LAB_CLONE_3.RETAIL.ORDERS |
