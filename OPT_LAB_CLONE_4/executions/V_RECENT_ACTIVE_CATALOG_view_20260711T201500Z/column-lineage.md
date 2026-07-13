# Column lineage

| Output column | Derived from | Transformation |
|---|---|---|
| PRODUCT_ID | `p.product_id` | none |
| PRODUCT_NAME | `p.product_name` | none |
| CATEGORY | `p.category` | none (filtered with `ILIKE`) |
| UNIT_PRICE | `p.unit_price` | none |

## Notes
- `inventory` (`i`) is used to constrain recency (`last_restocked` in current year) via join + date-range filters; no columns are selected from `i`.
