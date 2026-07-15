# Data Lineage

## Object lineage (high-level)
```mermaid
flowchart LR
  subgraph OPT_LAB_CLONE_5.RETAIL
    P[PRODUCTS]
    I[INVENTORY]
    V[V_RECENT_ACTIVE_CATALOG (VIEW)]
  end

  P -->|JOIN on product_id| V
  I -->|JOIN on product_id + filter last_restocked current year| V
```

## Notes
- The view returns product attributes from `PRODUCTS` for items that are:
  - in category `ELECTRONICS` (case-insensitive collation comparison)
  - active (`active_flag = TRUE`)
  - have inventory rows with `last_restocked` within the current calendar year
