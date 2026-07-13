# Column lineage

APPLY failed for this execution; column lineage is based on the prior definition (declared output columns) and the intended sources.

| Output column | Source | Expression |
|---|---|---|
| PRODUCT_ID | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.product_id` |
| PRODUCT_NAME | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.product_name` |
| CATEGORY | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.category` |
| UNIT_PRICE | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.unit_price` (expected) |
| ACTIVE_FLAG | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.active_flag` (expected) |

## Apply-time failure

The executed SQL referenced `p.price` and `p.active`, which triggered the compilation error:

- `invalid identifier 'P.PRICE'`
