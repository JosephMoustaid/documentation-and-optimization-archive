# Schema — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_LTV_RANKED

## Output columns
| Column | Notes |
|---|---|
| CUSTOMER_ID | from `customers.customer_id` |
| FIRST_NAME | from `customers.first_name` |
| LAST_NAME | from `customers.last_name` |
| LIFETIME_VALUE | from `customers.lifetime_value` |
| LTV_RANK | `DENSE_RANK() OVER (ORDER BY lifetime_value DESC)` |

## Referenced objects
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`
