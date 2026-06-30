# Optimization Execution Dashboard

- **Execution ID:** `exec-2026-06-30T00:00:01Z`
- **Timestamp:** `2026-06-30T00:00:01Z`
- **Warehouse:** `ADF_WH`
- **Execution Mode:** `APPLY`
- **Status:** `FAILED`

## Totals

| total_objects | successful_executions | failed_executions |
|---:|---:|---:|
| 1 | 0 | 1 |

## Results

### opt-1

- **Object URN:** `HEALTHCARE_STUDYCASE_DEV.UNKNOWN.UNKNOWN`
- **Object Type:** `VIEW`
- **Status:** `FAILED`

**Error**

> Optimized DDL is not a valid CREATE OR REPLACE statement. No concrete object definition was provided, so no Snowflake object can be created or replaced.

**Message**

Execution not performed because the provided SQL is only explanatory text, not an executable CREATE OR REPLACE VIEW/PROCEDURE/FUNCTION statement.

**Executed SQL (non-executable explanatory text)**

```sql
-- No valid object definition was provided in 'obje' (value is NULL),
-- and metadata discovery for database HEALTHCARE_STUDYCASE_DEV / warehouse ADF_WH failed.
-- Without a concrete CREATE VIEW / CREATE PROCEDURE / CREATE FUNCTION statement,
-- there is nothing to optimize.

-- Please re-run with a full object definition, for example:
--   {
--     'obje': "CREATE OR REPLACE VIEW HEALTHCARE_STUDYCASE_DEV.SCHEMA_X.VW_PATIENTS AS
--              SELECT ..."
--   }
-- or
--   {
--     'obje': "CREATE OR REPLACE PROCEDURE HEALTHCARE_STUDYCASE_DEV.SCHEMA_Y.SP_PROCESS_CLAIMS(...)
--              RETURNS ...
--              LANGUAGE SQL
--              AS $$
--              ...
--              $$;"
--   }

-- Once a concrete DDL statement is supplied, an optimized version can be generated.
```

## Notes

- No SQL changes were applied because no valid `CREATE OR REPLACE` definition was provided.
- To proceed, re-run with a concrete DDL statement for the target object (or enable metadata discovery for the referenced database/warehouse).
