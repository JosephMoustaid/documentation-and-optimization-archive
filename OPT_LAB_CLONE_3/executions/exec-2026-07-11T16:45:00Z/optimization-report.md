# Optimization Report — OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE

## Context
- **Execution:** exec-2026-07-11T16:45:00Z
- **Mode:** DRY_RUN
- **Warehouse:** ADF_WH
- **Object type:** PROCEDURE
- **Status:** VALIDATED (via EXPLAIN). **No changes applied**.

## Original approach
- Cursor iterates `PRODUCTS` rows for a given `CATEGORY`.
- For each `PRODUCT_ID`, executes an `UPDATE` of a single row.

### Impact
- Performs many small updates (row-by-row), increasing compilation/execution overhead and reducing optimizer flexibility.

## Proposed optimization
- Single **set-based** `UPDATE` against `OPT_LAB_CLONE_3.RETAIL.PRODUCTS` scoped by `CATEGORY = :CAT`.
- Captures affected row count using `SQLROWCOUNT`.

## Behavioral notes
- The optimized version updates **all products** in the requested category, which is equivalent to the cursor loop (cursor selects all `product_id` for that category).
- Rounding remains at 2 decimals.
- Return message updated to reflect set-based implementation.

## Validation
- DDL validated using **EXPLAIN** in **DRY_RUN** mode.
- Since this was a dry run, the repository contains **proposed** DDL only.

## Artifacts
- `previous.sql` — original procedure
- `optimized.sql` — proposed optimized procedure
- `procedure-flow.mmd` — control-flow overview
- `lineage.mmd` / `schema.mmd` — dependency context
