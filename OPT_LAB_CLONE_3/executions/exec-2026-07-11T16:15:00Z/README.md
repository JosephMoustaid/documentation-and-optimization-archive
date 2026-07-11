# Optimization Execution — exec-2026-07-11T16:15:00Z

This folder contains deterministic artifacts generated for a single optimization execution.

## Execution

- Execution ID: `exec-2026-07-11T16:15:00Z`
- Database: `OPT_LAB_CLONE_3`
- Warehouse: `ADF_WH`
- Mode: `DRY_RUN`
- Status: `FAILED`

## Artifacts

- `execution.json` — raw execution payload (results + errors)
- `previous.sql` — original object definition
- `optimized.sql` — proposed optimized definition (not applied in DRY_RUN)
- `optimization-report.md` — findings, changes, and failure analysis
- `schema.mmd` — Mermaid schema diagram for involved objects
- `lineage.mmd` — Mermaid lineage diagram
- `column-lineage.md` — column mapping notes
- `summary.md` — high-level summary

> Note: This run failed validation because the optimized SQL references `C.PHONE`, which does not exist in `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS`.
