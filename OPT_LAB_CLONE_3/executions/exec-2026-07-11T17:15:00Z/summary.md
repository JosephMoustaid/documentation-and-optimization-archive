# Execution Summary — exec-2026-07-11T17:15:00Z

- **Database:** OPT_LAB_CLONE_3
- **Warehouse:** ADF_WH
- **Execution mode:** DRY_RUN
- **Overall status:** FAILED
- **Objects:** 1 total • 0 successful • 1 failed

## Failure

- **Object:** `RETAIL.SP_RECALC_ORDER_TOTALS` (PROCEDURE)
- **Reason:** DRY_RUN validation failed because `CREATE PROCEDURE` used an **unqualified** schema name (`RETAIL`) without an active database context.
- **Fix:** Fully qualify the procedure name:
  - `CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_RECALC_ORDER_TOTALS ...`
  - or ensure the appropriate database is set before execution (e.g., `USE DATABASE OPT_LAB_CLONE_3;`).
