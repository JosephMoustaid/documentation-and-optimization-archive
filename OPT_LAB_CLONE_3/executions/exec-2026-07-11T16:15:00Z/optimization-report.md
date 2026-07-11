# Optimization report — OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS

## Context

- Execution: `exec-2026-07-11T16:15:00Z`
- Mode: `DRY_RUN`
- Status: `FAILED`

## Original definition issues

- Uses `c.*` which:
  - Increases bytes scanned by projecting unneeded columns.
  - Makes the view sensitive to upstream schema changes.
  - Can introduce name collisions (e.g., multiple `status` columns).
- Base objects were unqualified (relied on session context).

## Proposed changes (not applied)

- Replace `c.*` with an explicit column list.
- Fully qualify base tables with `OPT_LAB_CLONE_3.RETAIL`.
- Add explicit aliases to disambiguate columns:
  - `o.status AS order_status`
  - `c.status AS customer_status`

## Validation failure

- Error: `SQL compilation error: invalid identifier 'C.PHONE'`
- Meaning: Column `PHONE` does not exist in `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` (or is not accessible under current privileges).

## Recommended fix

1. Inspect `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` columns (e.g., `DESCRIBE TABLE ...`).
2. Remove `c.phone` from the projection or replace it with the correct column name.
3. Re-run optimization validation (DRY_RUN).

## Files

- `previous.sql` — original view
- `optimized.sql` — proposed optimized view (fails validation as-is)
- `lineage.mmd`, `schema.mmd`, `column-lineage.md` — documentation artifacts
