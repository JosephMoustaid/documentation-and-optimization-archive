# OPT_LAB_CLONE_4 — Execution exec-2026-07-11T19:00:00Z

This folder contains artifacts for optimizing/validating the Snowflake **procedure** `RETAIL.SP_APPLY_PRICE_INCREASE`.

## Status

- **Mode:** DRY_RUN
- **Result:** FAILED (validation)

## What failed

The `CREATE OR REPLACE PROCEDURE` statement referenced schema `RETAIL` without an active database context.

## How to remediate

Re-run validation/execution after one of:

- Using a fully qualified procedure name:

```sql
CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_4.RETAIL.SP_APPLY_PRICE_INCREASE(...)
```

- Or setting context prior to running the DDL:

```sql
USE DATABASE OPT_LAB_CLONE_4;
USE SCHEMA RETAIL;
```

## Files

- `execution.json` — raw execution payload
- `optimized.sql` — optimized DDL that was validated
- `previous.sql` — previous definition (not available for this run)
- `optimization-report.md` — error + remediation guidance
- `procedure-flow.md` — high-level flow of procedure logic
- `schema.md` — known context for this run
- `lineage.md`, `column-lineage.md` — placeholders (procedure; column lineage not derived)
- `summary.md` — quick summary
