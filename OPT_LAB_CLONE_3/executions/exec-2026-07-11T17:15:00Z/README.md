# Optimization Execution — exec-2026-07-11T17:15:00Z

This folder contains the serialized artifacts and documentation generated for the optimization run identified by `exec-2026-07-11T17:15:00Z`.

## Run metadata

- **Database:** `OPT_LAB_CLONE_3`
- **Warehouse:** `ADF_WH`
- **Execution mode:** `DRY_RUN`
- **Status:** `FAILED`
- **Total objects:** 1

## What happened

The run failed during DRY_RUN validation for a stored procedure because the procedure was created under the `RETAIL` schema **without a database-qualified name**.

## Files

- `execution.json` — raw execution payload
- `previous.sql` — previous definition (if available)
- `optimized.sql` — attempted optimized SQL/DDL
- `optimization-report.md` — narrative report including failure and remediation
- `procedure-flow.mmd` — Mermaid flow diagram (procedures)
- `schema.mmd`, `lineage.mmd`, `column-lineage.md` — included for completeness; may be minimal when validation fails
