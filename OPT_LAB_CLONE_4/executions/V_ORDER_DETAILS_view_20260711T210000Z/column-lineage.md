# Column lineage (best-effort)

> Derived from the attempted optimized view definition (which failed to compile due to invalid identifiers).

| Output column | Source |
|---|---|
| ORDER_ID | OPT_LAB_CLONE_4.RETAIL.ORDERS.order_id |
| ORDER_DATE | OPT_LAB_CLONE_4.RETAIL.ORDERS.order_date |
| STATUS | OPT_LAB_CLONE_4.RETAIL.ORDERS.status |
| CUSTOMER_ID | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.customer_id |
| FIRST_NAME | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.first_name |
| LAST_NAME | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.last_name |
| EMAIL | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.email |
| PHONE | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.phone *(invalid identifier per error)* |
| ADDRESS | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.address *(invalid identifier per message)* |
| CITY | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.city *(invalid identifier per message)* |
| STATE | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.state *(invalid identifier per message)* |
| POSTAL_CODE | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.postal_code *(invalid identifier per message)* |
| COUNTRY | OPT_LAB_CLONE_4.RETAIL.CUSTOMERS.country |
| PRODUCT_ID | OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS.product_id |
| QUANTITY | OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS.quantity |
| UNIT_PRICE | OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS.unit_price |
| PRODUCT_NAME | OPT_LAB_CLONE_4.RETAIL.PRODUCTS.product_name |
| CATEGORY | OPT_LAB_CLONE_4.RETAIL.PRODUCTS.category |
| PAYMENT_AMOUNT | OPT_LAB_CLONE_4.RETAIL.PAYMENTS.amount |
| PAYMENT_METHOD | OPT_LAB_CLONE_4.RETAIL.PAYMENTS.method |
| PAYMENT_STATUS | OPT_LAB_CLONE_4.RETAIL.PAYMENTS.status |
