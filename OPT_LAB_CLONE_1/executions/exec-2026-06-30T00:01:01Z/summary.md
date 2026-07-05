# Execution Summary

- **execution_id**: `exec-2026-06-30T00:01:01Z`
- **database**: `OPT_LAB_CLONE_1`
- **schema**: `ALL`
- **warehouse**: `ADF_WH`
- **execution_mode**: `APPLY`
- **status**: `FAILED`
- **total_objects**: 0
- **successful_executions**: 0
- **failed_executions**: 1
- **timestamp**: `2026-06-30T00:01:01Z`

## Failed Objects

### opt-1 — OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE (VIEW)

- **status**: `FAILED`
- **error**: Execution not performed in this run context; no Snowflake execution result is available.
- **message**: The optimized definition for OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE was received but not executed in this environment. Please run the provided CREATE OR REPLACE VIEW statement in your Snowflake account to apply the optimization.

See `view__RETAIL__V_SUPPLIER_PERFORMANCE.sql` for the proposed `CREATE OR REPLACE VIEW` statement.
