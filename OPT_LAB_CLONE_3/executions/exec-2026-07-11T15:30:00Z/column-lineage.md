# Column Lineage — OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS

> Note: Validation failed due to `invalid identifier 'C.PHONE'`. The mapping below reflects the *intended* optimized projection.

| View column | Source expression | Source table |
|---|---|---|
| ORDER_ID | `o.order_id` | `OPT_LAB_CLONE_3.RETAIL.ORDERS` |
| ORDER_DATE | `o.order_date` | `OPT_LAB_CLONE_3.RETAIL.ORDERS` |
| ORDER_STATUS | `o.status` | `OPT_LAB_CLONE_3.RETAIL.ORDERS` |
| CUSTOMER_ID | `c.customer_id` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| FIRST_NAME | `c.first_name` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| LAST_NAME | `c.last_name` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| EMAIL | `c.email` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| PHONE | `c.phone` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` (**INVALID COLUMN REFERENCE**) |
| CITY | `c.city` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| STATE | `c.state` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| COUNTRY | `c.country` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` |
| PRODUCT_ID | `oi.product_id` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS` |
| QUANTITY | `oi.quantity` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS` |
| UNIT_PRICE | `oi.unit_price` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS` |
| PRODUCT_NAME | `p.product_name` | `OPT_LAB_CLONE_3.RETAIL.PRODUCTS` |
| CATEGORY | `p.category` | `OPT_LAB_CLONE_3.RETAIL.PRODUCTS` |
| PAYMENT_AMOUNT | `pay.amount` | `OPT_LAB_CLONE_3.RETAIL.PAYMENTS` |
| PAYMENT_METHOD | `pay.method` | `OPT_LAB_CLONE_3.RETAIL.PAYMENTS` |
| PAYMENT_STATUS | `pay.status` | `OPT_LAB_CLONE_3.RETAIL.PAYMENTS` |
