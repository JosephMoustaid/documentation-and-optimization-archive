# Schema (inferred)

Object: `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS`

## Declared output columns (from previous definition)

The original view explicitly declares these columns:

| Column | Notes |
|---|---|
| PRODUCT_ID | from `products` |
| PRODUCT_NAME | from `products` |
| CATEGORY | from `products` |
| UNIT_PRICE | from `products` |
| ACTIVE_FLAG | from `products` |

The query body uses `p.*`, so the physical expansion depends on the current schema of `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` at runtime.

## Attempted output columns (from optimized definition)

The attempted optimized view SELECT list references:

- `p.product_id`
- `p.product_name`
- `p.category_id` (FAILED: invalid identifier)
- `p.price`
- `p.status`

## Source tables (from SQL)

- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (aliased `p`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (aliased `oi`)

## Unknowns / limitations

- Column data types are not available from the provided payload.
- The actual `PRODUCTS` column set is not provided; the runtime error indicates `CATEGORY_ID` does not exist.
