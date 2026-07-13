# Lineage (object-level)

## Target

- `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`

## Sources

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (`o`)
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (`c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (`oi`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (`p`)
- `OPT_LAB_CLONE_4.RETAIL.PAYMENTS` (`pay`) – optional via `LEFT JOIN`

## Join graph (logical)

`ORDERS` → `CUSTOMERS` (by `customer_id`) → `ORDER_ITEMS` (by `order_id`) → `PRODUCTS` (by `product_id`)

`PAYMENTS` is left-joined to `ORDERS` (by `order_id`).
