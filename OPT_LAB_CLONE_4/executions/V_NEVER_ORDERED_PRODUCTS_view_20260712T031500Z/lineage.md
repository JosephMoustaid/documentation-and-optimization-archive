# Lineage — V_NEVER_ORDERED_PRODUCTS

## Downstream object
- `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS`

## Upstream sources
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (alias `oi`) — used only for existence filtering

## Join / filter logic
- Anti-join filter:
  - `WHERE NOT EXISTS (SELECT 1 FROM ORDER_ITEMS oi WHERE oi.product_id = p.product_id)`
