# Lineage — V_CUSTOMER_ORDER_SUMMARY

## Object
- **View:** `OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

## Sources
- `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` (aliased `c`)
- `OPT_LAB_CLONE_3.RETAIL.ORDERS` (aggregated subquery `o_agg`)

## Transform summary
1. Read all columns from `CUSTOMERS`.
2. Aggregate `ORDERS` by `customer_id` to compute count, sum, and max order date.
3. Left join aggregates back to customers on `customer_id`.
4. Apply `COALESCE` defaults for numeric aggregates.
