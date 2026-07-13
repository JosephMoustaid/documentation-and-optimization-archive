# OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY (view)

This folder contains the optimization artifacts for execution `exec-2026-07-11T23:00:00Z`.

- **Database:** OPT_LAB_CLONE_4
- **Schema:** RETAIL
- **Object:** V_CUSTOMER_ORDER_SUMMARY
- **Object type:** view
- **Execution mode:** APPLY
- **Status:** FAILED

## What happened

The APPLY step failed because the optimized SQL referenced a non-existent column (`c.customer_name`) in `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`.

See:
- `optimization-report.md` for details
- `previous.sql` and `optimized.sql` for the exact SQL text used