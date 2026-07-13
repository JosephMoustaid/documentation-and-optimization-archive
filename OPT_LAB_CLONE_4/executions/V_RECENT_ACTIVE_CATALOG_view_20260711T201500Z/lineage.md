# Lineage

## Object-level lineage

**Target view**
- `OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG`

**Upstream sources**
- `OPT_LAB_CLONE_4.RETAIL.products` (p)
- `OPT_LAB_CLONE_4.RETAIL.inventory` (i)

## Relationship
- Inner join on `product_id`
- Filters:
  - `p.category ILIKE 'electronics'`
  - `i.last_restocked` restricted to current calendar year
  - `p.active_flag = TRUE`
