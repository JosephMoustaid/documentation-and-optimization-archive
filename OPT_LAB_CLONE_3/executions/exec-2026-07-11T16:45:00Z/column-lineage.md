# Column / Variable Lineage — OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE

Procedures do not expose a stable output column set like views. This note captures parameter/variable usage and table-column impacts.

## Parameters
- `CAT` (VARCHAR)
  - Used in predicate: `PRODUCTS.CATEGORY = :CAT`
- `PCT` (FLOAT)
  - Used in expression: `UNIT_PRICE * (1 + :PCT / 100.0)`

## Table writes
- `OPT_LAB_CLONE_3.RETAIL.PRODUCTS.UNIT_PRICE`
  - New value: `ROUND(UNIT_PRICE * (1 + :PCT / 100.0), 2)`

## Derived values
- `n` (NUMBER)
  - Set to `SQLROWCOUNT` after UPDATE
  - Used only for return message

## Notes
- DRY_RUN / VALIDATED: optimized DDL validated via EXPLAIN; no changes applied.
