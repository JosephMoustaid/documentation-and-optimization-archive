# Execution Summary

- **Execution ID:** exec-2026-07-11T19:00:00Z
- **Timestamp (UTC):** 2026-07-11T19:00:00Z
- **Database:** OPT_LAB_CLONE_4
- **Warehouse:** ADF_WH
- **Mode:** DRY_RUN
- **Status:** FAILED

## Object

- **URN:** RETAIL.SP_APPLY_PRICE_INCREASE
- **Type:** procedure
- **Task ID:** opt-1

## Outcome

Validation failed in DRY_RUN mode because the procedure was created without an active database context.

**Error:** SQL validation failed in DRY_RUN mode: Unable to run the CREATE PROCEDURE command because no database was specified for schema RETAIL. A fully qualified procedure name or explicit database context is required.

## Remediation

Choose one of the following and re-run:

1. Fully qualify the procedure name:

```sql
CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_4.RETAIL.SP_APPLY_PRICE_INCREASE(...)
```

2. Set database context before validation/execution:

```sql
USE DATABASE OPT_LAB_CLONE_4;
USE SCHEMA RETAIL;
```
