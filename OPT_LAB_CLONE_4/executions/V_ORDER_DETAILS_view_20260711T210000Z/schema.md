# Schema (best-effort, inferred)

## Target object

- **View:** `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`

## Source objects (from SQL)

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias `o`)
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (alias `c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (alias `oi`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.PAYMENTS` (alias `pay`, LEFT JOIN)

## Output columns

> Output columns are inferred from the attempted optimized `SELECT` list.

| Output column | Expression |
|---|---|
| ORDER_ID | o.order_id |
| ORDER_DATE | o.order_date |
| STATUS | o.status |
| CUSTOMER_ID | c.customer_id |
| FIRST_NAME | c.first_name |
| LAST_NAME | c.last_name |
| EMAIL | c.email |
| PHONE | c.phone *(invalid in current CUSTOMERS schema per error)* |
| ADDRESS | c.address *(invalid in current CUSTOMERS schema per message)* |
| CITY | c.city *(invalid in current CUSTOMERS schema per message)* |
| STATE | c.state *(invalid in current CUSTOMERS schema per message)* |
| POSTAL_CODE | c.postal_code *(invalid in current CUSTOMERS schema per message)* |
| COUNTRY | c.country |
| PRODUCT_ID | oi.product_id |
| QUANTITY | oi.quantity |
| UNIT_PRICE | oi.unit_price |
| PRODUCT_NAME | p.product_name |
| CATEGORY | p.category |
| PAYMENT_AMOUNT | pay.amount |
| PAYMENT_METHOD | pay.method |
| PAYMENT_STATUS | pay.status |
