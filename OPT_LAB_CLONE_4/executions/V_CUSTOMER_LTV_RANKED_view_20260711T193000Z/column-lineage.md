# Column lineage — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_LTV_RANKED

| Output column | Source expression |
|---|---|
| CUSTOMER_ID | `c.customer_id` from `OPT_LAB_CLONE_4.RETAIL.customers c` |
| FIRST_NAME | `c.first_name` from `OPT_LAB_CLONE_4.RETAIL.customers c` |
| LAST_NAME | `c.last_name` from `OPT_LAB_CLONE_4.RETAIL.customers c` |
| LIFETIME_VALUE | `c.lifetime_value` from `OPT_LAB_CLONE_4.RETAIL.customers c` |
| LTV_RANK | `DENSE_RANK() OVER (ORDER BY c.lifetime_value DESC)` derived from `c.lifetime_value` |
