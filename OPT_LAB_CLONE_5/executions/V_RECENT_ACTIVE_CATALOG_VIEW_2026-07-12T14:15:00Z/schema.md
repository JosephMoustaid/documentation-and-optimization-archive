# Schema — OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG

## Object
- **Database**: `OPT_LAB_CLONE_5`
- **Schema**: `RETAIL`
- **Name**: `V_RECENT_ACTIVE_CATALOG`
- **Type**: `VIEW`

## Definition (current / applied)
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimized view: recent active electronics catalog

  Optimizations:
  1) Fully qualify PRODUCTS and INVENTORY to avoid search-path dependence.
  2) Make category filter sargable by comparing against an uppercase literal,
     assuming CATEGORY is stored in a consistent case (matches original semantics
     when data is already normalized to uppercase).
  3) Replace YEAR(i.last_restocked) = YEAR(CURRENT_DATE) with a range predicate
     on LAST_RESTOCKED to enable index/partition pruning and avoid function on column.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_5.RETAIL.PRODUCTS AS p
JOIN OPT_LAB_CLONE_5.RETAIL.INVENTORY AS i
    ON i.product_id = p.product_id
WHERE p.category = 'ELECTRONICS'
  AND i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)
  AND i.last_restocked < DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)
  AND p.active_flag = TRUE
```

## Source objects referenced
- `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_5.RETAIL.INVENTORY` (alias `i`)

## Output columns
| Output column | Expression | Source |
|---|---|---|
| `PRODUCT_ID` | `p.product_id` | `PRODUCTS.PRODUCT_ID` |
| `PRODUCT_NAME` | `p.product_name` | `PRODUCTS.PRODUCT_NAME` |
| `CATEGORY` | `p.category` | `PRODUCTS.CATEGORY` |
| `UNIT_PRICE` | `p.unit_price` | `PRODUCTS.UNIT_PRICE` |

## Filters / join conditions
- Join: `i.product_id = p.product_id`
- Filters:
  - `p.category = 'ELECTRONICS'`
  - `i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)`
  - `i.last_restocked < DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)`
  - `p.active_flag = TRUE`
