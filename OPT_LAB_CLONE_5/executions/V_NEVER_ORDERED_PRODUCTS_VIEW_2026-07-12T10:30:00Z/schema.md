# Schema (Inferred): OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS

> Note: This execution **FAILED** during APPLY. The schema below is inferred from the view DDLs provided and may not reflect the actual `PRODUCTS` table schema.

## View signature (previous definition)

The prior view definition declared the following output columns:

| ordinal | column_name   | notes |
|--------:|---------------|-------|
| 1 | PRODUCT_ID   | from `products` |
| 2 | PRODUCT_NAME | from `products` |
| 3 | CATEGORY     | from `products` |
| 4 | UNIT_PRICE   | from `products` |
| 5 | ACTIVE_FLAG  | from `products` |

## Attempted optimized projection (failed)

The attempted optimized SQL projected:

| ordinal | column_name   | source alias | status |
|--------:|---------------|--------------|--------|
| 1 | PRODUCT_ID   | `p` | expected |
| 2 | PRODUCT_NAME | `p` | expected |
| 3 | CATEGORY     | `p` | expected |
| 4 | PRICE        | `p` | **invalid identifier in PRODUCTS** (`P.PRICE`) |
| 5 | CREATED_AT   | `p` | may be invalid (not confirmed) |

## Referenced base objects

- `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS` (alias `oi`)
