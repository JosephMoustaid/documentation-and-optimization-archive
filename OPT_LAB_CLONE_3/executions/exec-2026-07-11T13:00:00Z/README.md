# OPT_LAB_CLONE_3 — Execution exec-2026-07-11T13:00:00Z

This folder contains the persisted SQL artifacts and generated documentation for a single optimization execution.

## Execution

- **Execution ID:** exec-2026-07-11T13:00:00Z
- **Timestamp:** 2026-07-11T13:00:00Z
- **Warehouse:** ADF_WH
- **Mode:** DRY_RUN
- **Status:** FAILED

## What failed

The optimized view definition referenced `c.phone`, which does not exist in `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS`.

- Reported error: `invalid identifier 'C.PHONE'`

## Files in this directory

- `execution.json` — raw execution payload
- `previous.sql` — previous object definition
- `optimized.sql` — proposed optimized definition (failed validation)
- `optimization-report.md` — optimization notes and recommendations
- `schema.mmd` — Mermaid ERD-style schema diagram (tables involved)
- `lineage.mmd` — Mermaid lineage diagram (object-to-object)
- `column-lineage.md` — column mapping and notes
