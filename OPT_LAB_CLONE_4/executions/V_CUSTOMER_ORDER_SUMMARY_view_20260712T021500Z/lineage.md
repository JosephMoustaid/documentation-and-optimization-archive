# Lineage

## Object lineage

`OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- depends on `OPT_LAB_CLONE_4.RETAIL.customers`
- depends on `OPT_LAB_CLONE_4.RETAIL.orders`

## Join + aggregation
- `customers` LEFT JOIN aggregated `orders` grouped by `orders.customer_id`
