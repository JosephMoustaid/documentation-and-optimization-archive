# Column Lineage: OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG

## Column Mapping

| Output Column | Source Column(s) | Transformation |
|---|---|---|
| PRODUCT_ID | PRODUCTS.PRODUCT_ID | Direct projection (`p.product_id`) |
| PRODUCT_NAME | PRODUCTS.PRODUCT_NAME | Direct projection (`p.product_name`) |
| CATEGORY | PRODUCTS.CATEGORY | Direct projection (`p.category`); filtered with case-insensitive COLLATE (`p.category COLLATE "en-ci" = 'ELECTRONICS'`) |
| UNIT_PRICE | PRODUCTS.UNIT_PRICE | Direct projection (`p.unit_price`) |

## Filtering / Predicate Lineage

- `PRODUCTS.CATEGORY` participates in the category filter.
- `INVENTORY.LAST_RESTOCKED` participates in the current-year date-range filter.
- `PRODUCTS.ACTIVE_FLAG` participates in the active flag filter.

## Join Lineage

- `PRODUCTS.PRODUCT_ID` joins to `INVENTORY.PRODUCT_ID`.
