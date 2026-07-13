# Column lineage (best-effort)

The APPLY attempt failed to compile; column lineage below is derived from the SQL text and the previous view column list.

## Mappings

| Output column | Source expression |
|---|---|
| ORDER_ID | `o.order_id` |
| ORDER_DATE | `o.order_date` |
| STATUS | `o.status` (previous) / `o.status AS order_status` (attempted) |
| CUSTOMER_ID | `c.customer_id` (attempted) / `c.*` (previous) |
| FIRST_NAME | `c.*` (previous; explicit column not listed in attempted SQL) |
| LAST_NAME | `c.*` (previous; explicit column not listed in attempted SQL) |
| EMAIL | `c.email` (attempted) / `c.*` (previous) |
| COUNTRY | `c.*` (previous) |
| SIGNUP_DATE | `c.*` (previous) |
| IS_ACTIVE | `c.*` (previous) |
| LIFETIME_VALUE | `c.*` (previous) |
| PRODUCT_ID | `oi.product_id` |
| QUANTITY | `oi.quantity` |
| UNIT_PRICE | `oi.unit_price` |
| PRODUCT_NAME | `p.product_name` |
| CATEGORY | `p.category` |
| PAYMENT_AMOUNT | `pay.amount` |
| PAYMENT_METHOD | `pay.method` |
| PAYMENT_STATUS | `pay.status` |

## Invalid references in attempted SQL

- `c.customer_name`
- `c.phone`
- `c.address`
