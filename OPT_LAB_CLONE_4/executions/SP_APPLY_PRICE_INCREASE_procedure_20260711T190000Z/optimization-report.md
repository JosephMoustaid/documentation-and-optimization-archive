# Optimization Report — `RETAIL.SP_APPLY_PRICE_INCREASE`

## Execution

- **Execution ID:** exec-2026-07-11T19:00:00Z
- **Mode:** DRY_RUN
- **Warehouse:** ADF_WH
- **Database:** OPT_LAB_CLONE_4

## Status

- **Result:** FAILED (SQL validation)

## Error

SQL validation failed in DRY_RUN mode: Unable to run the CREATE PROCEDURE command because no database was specified for schema RETAIL. A fully qualified procedure name or explicit database context is required.

## Why this happened

In Snowflake, a two-part name (`schema.object`) requires an active database context. In DRY_RUN validation, there was no `USE DATABASE` context set when attempting to validate:

```sql
CREATE OR REPLACE PROCEDURE RETAIL.SP_APPLY_PRICE_INCREASE(...)
```

## Remediation guidance

### Option A — Fully qualify the procedure name

```sql
CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_4.RETAIL.SP_APPLY_PRICE_INCREASE(
  cat VARCHAR,
  pct NUMBER
)
...
```

### Option B — Set database/schema context before running DDL

```sql
USE DATABASE OPT_LAB_CLONE_4;
USE SCHEMA RETAIL;

CREATE OR REPLACE PROCEDURE RETAIL.SP_APPLY_PRICE_INCREASE(...);
```

## Next steps

- Apply one remediation option above.
- Re-run the pipeline in DRY_RUN to validate.
- If validation passes, re-run in execution mode that applies changes.
