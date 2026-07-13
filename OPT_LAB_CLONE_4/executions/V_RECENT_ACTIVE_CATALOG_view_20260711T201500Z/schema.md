# Schema (inferred)

## View
- **Name:** `OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG`
- **Type:** view

## Output columns
| Column | Source | Notes |
|---|---|---|
| PRODUCT_ID | `products.product_id` | passthrough |
| PRODUCT_NAME | `products.product_name` | passthrough |
| CATEGORY | `products.category` | filtered with `ILIKE 'electronics'` |
| UNIT_PRICE | `products.unit_price` | passthrough |

## Referenced objects
- `OPT_LAB_CLONE_4.RETAIL.products` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.inventory` (alias `i`)

## Join keys
- `i.product_id = p.product_id`
