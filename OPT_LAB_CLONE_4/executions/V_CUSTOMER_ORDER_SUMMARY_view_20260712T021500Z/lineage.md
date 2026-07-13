# Lineage — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Sources
- `OPT_LAB_CLONE_4.RETAIL.customers` (base table)
- `OPT_LAB_CLONE_4.RETAIL.orders` (base table; aggregated by `customer_id`)

## Transform
- `customers` LEFT JOIN aggregated `orders` per `customer_id`.

## Output
- View: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
