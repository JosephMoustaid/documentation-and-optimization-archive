# Execution Summary — exec-2026-06-30T00:00:51Z

- **Database:** HAFID_OPTIM_CLONE_1
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** FAILED
- **Objects:** 1 total (0 succeeded, 1 failed)

## Failed object
- **Object:** `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL` (VIEW)
- **Error:** `SQL compilation error: syntax error line 24 at position 0 unexpected 'CREATE'.`
- **Root cause:** The executed SQL contained **two** `CREATE OR REPLACE VIEW` statements in a single command.

## Recommended fix
Snowflake allows only one DDL statement per execution. Keep the outer header and remove the inner duplicate `CREATE OR REPLACE VIEW ... AS`.

A corrected candidate is provided in `optimized.sql`.
