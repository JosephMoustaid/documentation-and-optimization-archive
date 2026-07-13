# Lineage — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

## Upstream objects
- `OPT_LAB_CLONE_4.RETAIL.INVENTORY` (base table; alias `i`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (lookup; alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.SUPPLIERS` (lookup; alias `s`)

## Downstream object
- `OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK` (view)

## Join graph
- `inventory i`
  - `LEFT JOIN products p` on `p.product_id = i.product_id`
  - `LEFT JOIN suppliers s` on `s.supplier_id = i.supplier_id`

## Filter
- `i.qty_on_hand < i.reorder_level`
