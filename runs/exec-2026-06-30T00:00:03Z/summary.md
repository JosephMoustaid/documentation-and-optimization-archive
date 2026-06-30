# Optimization Run Summary

- **Execution ID:** exec-2026-06-30T00:00:03Z
- **Timestamp:** 2026-06-30T00:00:03Z
- **Warehouse:** UNKNOWN
- **Mode:** APPLY
- **Status:** FAILED
- **Objects:** 1 total / 0 succeeded / 1 failed

## Failure reason
The provided input did not include a concrete executable object DDL. `previous_definition` / object definition was `NULL`, and the only SQL content was explanatory comments, not a `CREATE OR REPLACE ...` statement. Therefore **no SQL changes were applied**.

## Failed task(s)
- **task_id:** opt-1
- **object_urn:** HAFID_OPTIM_CLONE_1.UNKNOWN.UNKNOWN
- **object_type:** VIEW
- **error:** Provided content is not an executable CREATE OR REPLACE statement; it is only explanatory text with no concrete object DDL, so no Snowflake object can be created or replaced.
- **message:** No changes were applied. Please re-run with a full object DDL such as: `CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.<schema>.<view_name> AS SELECT ...` or `CREATE OR REPLACE PROCEDURE HAFID_OPTIM_CLONE_1.<schema>.<procedure_name>(...) ...`
