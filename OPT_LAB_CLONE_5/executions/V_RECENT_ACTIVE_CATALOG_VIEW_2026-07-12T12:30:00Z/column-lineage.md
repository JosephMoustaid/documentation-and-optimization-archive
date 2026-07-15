# Column Lineage

## Column mappings
| View column | Source expression | Source table.column | Transformation |
|---|---|---|---|
| `product_id` | `p.product_id` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.product_id` | None |
| `product_name` | `p.product_name` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.product_name` | None |
| `category` | `p.category` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.category` | None (filtered with `COLLATE "en-ci"` in WHERE) |
| `unit_price` | `p.unit_price` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.unit_price` | None |

## Predicate lineage (filters)
| Predicate | Column(s) referenced | Purpose |
|---|---|---|
| `p.category COLLATE "en-ci" = 'ELECTRONICS'` | `PRODUCTS.category` | Case-insensitive category filter without applying a function to the column |
| `p.active_flag = TRUE` | `PRODUCTS.active_flag` | Only active products |
| `i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)` | `INVENTORY.last_restocked` | Start of current year (inclusive) |
| `i.last_restocked < DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)` | `INVENTORY.last_restocked` | Start of next year (exclusive) |

## Join lineage
| Join | Left | Right |
|---|---|---|
| `i.product_id = p.product_id` | `INVENTORY.product_id` | `PRODUCTS.product_id` |
