# Lineage (object-level)

## Target

- `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`

## Direct sources

Based on SQL (previous and attempted optimized):

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias `o`)
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (alias `c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (alias `oi`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.PAYMENTS` (alias `pay`, left join)

## Notes

- The APPLY attempt failed during compilation; lineage reflects intended references in the SQL text.
