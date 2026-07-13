# Schema — V_RECENT_ACTIVE_CATALOG

## Object
- **View:** `OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG`

## Upstream sources
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.INVENTORY` (alias `i`)

## Join logic
- `i.product_id = p.product_id`

## Output columns
| Output column | Source expression | Source table |
|---|---|---|
| `PRODUCT_ID` | `p.product_id` | PRODUCTS |
| `PRODUCT_NAME` | `p.product_name` | PRODUCTS |
| `CATEGORY` | `p.category` | PRODUCTS |
| `UNIT_PRICE` | `p.unit_price` | PRODUCTS |

## Filters
- Category: `UPPER(p.category) = 'ELECTRONICS'` (previously `p.category ILIKE 'electronics'`)
- Restock date (current year):
  - `i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)`
  - `i.last_restocked <  DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)`
- Active products: `p.active_flag = TRUE`
