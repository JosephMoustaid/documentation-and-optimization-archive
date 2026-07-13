# Lineage — V_CUSTOMER_ORDER_SUMMARY

## Object-level lineage

**Target view:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

**Upstream sources:**

- `OPT_LAB_CLONE_4.RETAIL.customers` (driving table)
- `OPT_LAB_CLONE_4.RETAIL.orders` (aggregated by `customer_id`)

## Join pattern

- `customers` LEFT JOIN aggregated `orders` on `customer_id`.
