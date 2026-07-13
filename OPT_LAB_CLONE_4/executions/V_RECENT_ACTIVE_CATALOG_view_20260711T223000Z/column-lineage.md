# Column lineage — V_RECENT_ACTIVE_CATALOG

| View column | Expression | Upstream column(s) |
|---|---|---|
| `PRODUCT_ID` | `p.product_id` | `PRODUCTS.product_id` |
| `PRODUCT_NAME` | `p.product_name` | `PRODUCTS.product_name` |
| `CATEGORY` | `p.category` | `PRODUCTS.category` |
| `UNIT_PRICE` | `p.unit_price` | `PRODUCTS.unit_price` |

## Predicates / non-projected dependencies
- `PRODUCTS.category` (category filter)
- `INVENTORY.last_restocked` (date range filter)
- `PRODUCTS.active_flag` (active filter)
- `PRODUCTS.product_id`, `INVENTORY.product_id` (join keys)
