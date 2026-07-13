# OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS (FAILED APPLY)

This folder contains the execution artifacts for the failed APPLY attempt:

- **Execution ID:** exec-2026-07-12T03:30:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** FAILED

## Root cause

The attempted optimized view referenced non-existent columns on `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`, including:

- `C.PHONE`
- `C.ADDRESS`
- `C.CITY`
- `C.STATE`
- `C.POSTAL_CODE`

See `optimization-report.md` for details.
