# OPT_LAB_CLONE_4 • V_NEVER_ORDERED_PRODUCTS (view)

Execution folder: `OPT_LAB_CLONE_4/executions/V_NEVER_ORDERED_PRODUCTS_view_20260712T013000Z/`

## What this contains

This folder contains the serialized execution payload and generated documentation artifacts for the optimization/apply run.

## Key files

- `execution.json` — full execution payload captured at runtime
- `previous.sql` — previous object definition
- `optimized.sql` — SQL that was executed (failed)
- `optimization-report.md` — failure details and recommended fix
- `schema.md`, `lineage.md`, `column-lineage.md` — documentation artifacts (may be partial due to failure)

## Status

This execution **FAILED** during APPLY due to invalid identifiers (`P.PRICE`, `P.ACTIVE`) in the optimized view SQL.
