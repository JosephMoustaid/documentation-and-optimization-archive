# OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS (view)

This folder contains the persisted optimization artifacts for the execution:

- **Execution ID:** exec-2026-07-11T21:00:00Z
- **Timestamp:** 2026-07-11T21:00:00Z
- **Mode:** APPLY
- **Warehouse:** ADF_WH
- **Status:** FAILED

## Files

- `previous.sql` — previous view definition.
- `optimized.sql` — attempted optimized definition (failed to apply).
- `execution.json` — full execution payload for this object.
- `summary.md` — high-level outcome.
- `schema.md` — inferred inputs/outputs schema (best-effort from SQL text).
- `lineage.md` — object-level lineage.
- `column-lineage.md` — column-level lineage (best-effort).
- `optimization-report.md` — optimization notes + failure details.

## Failure details

SQL compilation error due to invalid customer columns referenced in the optimized definition (e.g., `C.PHONE`). See `summary.md` and `optimization-report.md`.
