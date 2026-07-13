# Lineage (object-level)

## Target

- `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`

## Upstream dependencies (from SQL)

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` → `V_ORDER_DETAILS`
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` → `V_ORDER_DETAILS`
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` → `V_ORDER_DETAILS`
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` → `V_ORDER_DETAILS`
- `OPT_LAB_CLONE_4.RETAIL.PAYMENTS` (LEFT JOIN) → `V_ORDER_DETAILS`

## Join conditions

- `ORDERS o` JOIN `CUSTOMERS c` ON `c.customer_id = o.customer_id`
- `ORDERS o` JOIN `ORDER_ITEMS oi` ON `oi.order_id = o.order_id`
- `ORDER_ITEMS oi` JOIN `PRODUCTS p` ON `p.product_id = oi.product_id`
- `PAYMENTS pay` LEFT JOIN on `pay.order_id = o.order_id`
