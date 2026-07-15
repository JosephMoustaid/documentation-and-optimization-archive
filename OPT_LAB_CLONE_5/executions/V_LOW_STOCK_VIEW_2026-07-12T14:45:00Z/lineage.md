# Lineage — OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK

## Upstream objects
- `OPT_LAB_CLONE_5.RETAIL.INVENTORY` (base table)
- `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` (lookup)
- `OPT_LAB_CLONE_5.RETAIL.SUPPLIERS` (lookup)

## Lineage diagram
```mermaid
flowchart LR
  V["VIEW\nOPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK"]
  I["TABLE\nOPT_LAB_CLONE_5.RETAIL.INVENTORY"]
  P["TABLE\nOPT_LAB_CLONE_5.RETAIL.PRODUCTS"]
  S["TABLE\nOPT_LAB_CLONE_5.RETAIL.SUPPLIERS"]

  I --> V
  P --> V
  S --> V
```

## Notes
- `PRODUCTS` and `SUPPLIERS` are joined with `LEFT JOIN` to enrich inventory rows with names.
- The low-stock condition is applied on `INVENTORY` quantities.
