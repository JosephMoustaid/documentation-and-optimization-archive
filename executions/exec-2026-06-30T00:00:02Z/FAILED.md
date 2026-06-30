# Execution FAILED

- **execution_id:** `exec-2026-06-30T00:00:02Z`
- **timestamp:** `2026-06-30T00:00:02Z`
- **warehouse:** `UNKNOWN`
- **execution_mode:** `APPLY`
- **total_objects:** 1
- **successful_executions:** 0
- **failed_executions:** 1

## Failures

### opt-1
- **object_urn:** `HAFID_OPTIM_CLONE_1.UNKNOWN.UNKNOWN`
- **object_type:** `VIEW`
- **error:** Optimized DDL is not a valid CREATE OR REPLACE statement. The provided content is explanatory text with no concrete object DDL, so no Snowflake object can be created or replaced.
- **message:** Execution not performed because the supplied SQL is only guidance text, not an executable CREATE OR REPLACE VIEW/PROCEDURE/FUNCTION statement. Please re-run with a full object definition such as: CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.<schema>.<view_name> AS SELECT ... or CREATE OR REPLACE PROCEDURE HAFID_OPTIM_CLONE_1.<schema>.<procedure_name>(...) ...
