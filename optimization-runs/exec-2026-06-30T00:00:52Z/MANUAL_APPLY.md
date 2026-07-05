# Manual Apply Required (Snowflake)

Execution ID: `exec-2026-06-30T00:00:52Z`

Status: **FAILED** (not executed in this environment)

## Why this is marked FAILED
This run produced optimized SQL but did not execute it against Snowflake in the current run context, so no execution result is available.

## How to apply
Run the SQL in your Snowflake account (using warehouse `ADF_WH`):

- Object: `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH`
- Script: `objects/HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH/optimized.sql`

### Suggested steps
1. Review the SQL.
2. Execute in Snowflake:
   ```sql
   -- See file: objects/HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH/optimized.sql
   ```
3. Validate:
   - `SELECT * FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH LIMIT 10;`
   - Compare row counts/metrics vs prior behavior.

## Notes
- No `previous_definition` was provided for this object in this execution payload.
