# Optimization Execution Dashboard

- **Database:** `OPT_LAB_CLONE_5`
- **Execution ID:** `exec-2026-07-15T00:00:00Z`
- **Warehouse:** `ADF_WH`
- **Execution Mode:** `APPLY`
- **Overall Status:** `FAILED`
- **Total Objects:** 1
- **Successful Executions:** 0
- **Failed Executions:** 1
- **Timestamp:** `2026-07-15T00:00:00Z`

## Objects

| Task ID | Object URN | Object Type | Status | Execution Time (ms) |
|---|---|---|---|---|
| opt-2 | `OPT_LAB_CLONE_5.RETAIL.SP_RECALC_ORDER_TOTALS` | PROCEDURE | FAILED |  |

## Failure Details

### opt-2 — `OPT_LAB_CLONE_5.RETAIL.SP_RECALC_ORDER_TOTALS`

- **Error:** Unable to run the CREATE PROCEDURE command. You must specify the database to use by either setting the database field in the body of the request or by setting the DEFAULT_NAMESPACE property for the current user.
- **Message:** APPLY execution failed: target database not set; procedure was not created or replaced.
