# Column lineage (best-effort)

This is derived from the SQL text; the APPLY failed, so this mapping is informational.

| Output column | Source expression | Notes |
|---|---|---|
| ORDER_ID | `o.order_id` | |
| ORDER_DATE | `o.order_date` | |
| STATUS / ORDER_STATUS | `o.status` | Previous definition aliases to `order_status`; executed SQL leaves as `status`. |
| CUSTOMER_ID | `c.customer_id` | |
| FIRST_NAME | `c.first_name` | |
| LAST_NAME | `c.last_name` | |
| EMAIL | `c.email` | |
| PHONE | `c.phone` | **Invalid identifier (compile error)** |
| CREATED_AT | `c.created_at` | Likely non-existent |
| CUSTOMER_STATUS | `c.status` | Likely non-existent / mismatched |
| PRODUCT_ID | `oi.product_id` | |
| QUANTITY | `oi.quantity` | |
| UNIT_PRICE | `oi.unit_price` | |
| PRODUCT_NAME | `p.product_name` | |
| CATEGORY | `p.category` | |
| PAYMENT_AMOUNT | `pay.amount` | |
| PAYMENT_METHOD | `pay.method` | |
| PAYMENT_STATUS | `pay.status` | |
