# Column lineage (best-effort)

Object: `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS`

Because the original definition uses `p.*` and the `PRODUCTS` table schema is not provided, column-level lineage is inferred from the **declared** output columns and the filter condition.

## Output columns (declared) → source

| Output column | Source | Expression |
|---|---|---|
| PRODUCT_ID | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.product_id` (implied via `p.*`) |
| PRODUCT_NAME | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.product_name` (implied via `p.*`) |
| CATEGORY | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.category` (implied; name based on declared output) |
| UNIT_PRICE | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.unit_price` (implied; name based on declared output) |
| ACTIVE_FLAG | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` | `p.active_flag` (implied; name based on declared output) |

## Predicate lineage

| Predicate | Upstream columns |
|---|---|
| `NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id)` | `oi.product_id`, `p.product_id` |

## APPLY attempt note

The attempted optimized SELECT list referenced `p.category_id`, `p.price`, and `p.status`, and failed with:

> SQL compilation error: error line 5 at position 4 invalid identifier 'P.CATEGORY_ID'

This indicates at least `CATEGORY_ID` is not present in `PRODUCTS`.
