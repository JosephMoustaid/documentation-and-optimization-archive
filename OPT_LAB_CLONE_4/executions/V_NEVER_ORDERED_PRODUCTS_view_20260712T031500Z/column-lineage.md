# Column lineage (best-effort)

The optimized view selects `p.*`, so each output column is a direct pass-through from `OPT_LAB_CLONE_4.RETAIL.PRODUCTS`.

## Mappings
- `V_NEVER_ORDERED_PRODUCTS.<col>` → `PRODUCTS.<col>` (1:1 pass-through)

## Filter lineage
- Row exclusion is driven by the existence of matching `ORDER_ITEMS` rows:
  - match condition: `ORDER_ITEMS.PRODUCT_ID = PRODUCTS.PRODUCT_ID`
