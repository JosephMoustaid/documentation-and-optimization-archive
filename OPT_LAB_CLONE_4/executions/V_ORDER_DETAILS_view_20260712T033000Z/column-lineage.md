# Column lineage (high level)

APPLY failed due to `invalid identifier 'C.PHONE'`. Column lineage below reflects the *intended* mapping from the SQL text.

| Output column | Source expression |
|---|---|
| ORDER_ID | `o.order_id` |
| ORDER_DATE | `o.order_date` |
| ORDER_STATUS / STATUS | `o.status` (previous used `AS order_status`) |
| CUSTOMER_ID | `c.customer_id` |
| FIRST_NAME | `c.first_name` |
| LAST_NAME | `c.last_name` |
| EMAIL | `c.email` |
| COUNTRY | `c.country` |
| SIGNUP_DATE | `c.signup_date` *(previous definition only)* |
| IS_ACTIVE | `c.is_active` *(previous definition only)* |
| LIFETIME_VALUE | `c.lifetime_value` *(previous definition only)* |
| PRODUCT_ID | `oi.product_id` |
| QUANTITY | `oi.quantity` |
| UNIT_PRICE | `oi.unit_price` |
| PRODUCT_NAME | `p.product_name` |
| CATEGORY | `p.category` |
| PRODUCT_UNIT_PRICE | `p.unit_price` *(previous definition only, aliased)* |
| PRODUCT_ACTIVE_FLAG | `p.active_flag` *(previous definition only, aliased)* |
| PAYMENT_AMOUNT | `pay.amount` |
| PAYMENT_METHOD | `pay.method` |
| PAYMENT_STATUS | `pay.status` |
| PAYMENT_TIMESTAMP | `pay.paid_at` *(previous definition only, aliased)* |

Invalid references in attempted optimized SQL:
- `c.phone`, `c.address`, `c.city`, `c.state`, `c.postal_code`
