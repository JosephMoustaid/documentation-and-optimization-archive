# Schema (best-effort)

## View
- **Name**: `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS`

## Output columns
The optimized SQL projects `p.*` from `OPT_LAB_CLONE_4.RETAIL.PRODUCTS`.

Because the base table DDL was not provided in the payload, exact column names/types cannot be guaranteed here.

### Expected columns (from prior view signature)
- `PRODUCT_ID`
- `PRODUCT_NAME`
- `CATEGORY`
- `UNIT_PRICE`
- `ACTIVE_FLAG`

> Note: if `PRODUCTS` contains additional columns beyond the prior signature, the optimized view will expose them due to `p.*`.
