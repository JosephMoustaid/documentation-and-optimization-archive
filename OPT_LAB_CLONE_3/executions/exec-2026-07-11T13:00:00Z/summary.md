# Execution Summary — exec-2026-07-11T13:00:00Z

- **Database:** OPT_LAB_CLONE_3
- **Warehouse:** ADF_WH
- **Mode:** DRY_RUN
- **Timestamp:** 2026-07-11T13:00:00Z
- **Overall status:** FAILED

## Results

- **Total objects:** 1
- **Succeeded:** 0
- **Failed:** 1

### Failed object

- **Task:** opt-1
- **Object:** OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS (VIEW)
- **Error:** SQL compilation error: error line 12 at position 4 invalid identifier 'C.PHONE'
- **Message:** Validation FAILED in DRY_RUN mode. The optimized VIEW definition references a non-existent column (C.PHONE) in OPT_LAB_CLONE_3.RETAIL.CUSTOMERS. Please either remove c.phone from the select list or ensure that the CUSTOMERS table/view includes a PHONE column before re-running.
