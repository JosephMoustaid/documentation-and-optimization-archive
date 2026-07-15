# Lineage — OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG

## Overview
This view exposes the **active** products in the **ELECTRONICS** category that have inventory restocked **during the current calendar year**.

## Object-level lineage
```mermaid
flowchart LR
  P[(OPT_LAB_CLONE_5.RETAIL.PRODUCTS)] -->|join on product_id| V[OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG]
  I[(OPT_LAB_CLONE_5.RETAIL.INVENTORY)] -->|join on product_id + restocked date range| V
```

## Notes on applied optimization
- Removed function-on-column predicate `UPPER(p.category)` in favor of `p.category = 'ELECTRONICS'` (assumes normalized case aligns with prior behavior).
- Replaced `YEAR(i.last_restocked) = YEAR(CURRENT_DATE)` with a sargable range predicate for partition pruning.
- Fully qualified base tables.
