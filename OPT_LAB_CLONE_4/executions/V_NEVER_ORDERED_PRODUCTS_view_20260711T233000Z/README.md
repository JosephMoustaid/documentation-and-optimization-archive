# OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS (view)

Execution folder: `V_NEVER_ORDERED_PRODUCTS_view_20260711T233000Z`

## Result

This execution **FAILED** during APPLY.

### Error

`SQL compilation error: error line 5 at position 4 invalid identifier 'P.CATEGORY_ID'`

### Likely cause

The optimized view definition references columns not present in `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (e.g., `CATEGORY_ID`, `PRICE`, `STATUS`).

### Recommended fix

Update the SELECT list to use valid columns (for example: `PRODUCT_ID`, `PRODUCT_NAME`, `CATEGORY`, `UNIT_PRICE`, `ACTIVE_FLAG`) and re-run.

## Files

- `execution.json` — raw execution payload
- `previous.sql` — original view definition
- `optimized.sql` — attempted optimized definition (failed)
- `optimization-report.md` — failure analysis
- `schema.md`, `lineage.md`, `column-lineage.md` — documentation derived from SQL
