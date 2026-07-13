# Execution Summary

- Execution ID: exec-2026-07-11T23:30:00Z
- Timestamp: 2026-07-11T23:30:00Z
- Warehouse: ADF_WH
- Mode: APPLY
- Status: FAILED

## Object

- Task ID: opt-1
- Object: OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS
- Type: VIEW

## Failure

- Error: SQL compilation error: error line 5 at position 4 invalid identifier 'P.CATEGORY_ID'
- Message: Execution FAILED in APPLY mode. The optimized VIEW definition references one or more product columns (for example P.CATEGORY_ID, P.PRICE, P.STATUS) that do not exist in OPT_LAB_CLONE_4.RETAIL.PRODUCTS. Adjust the SELECT list to use only valid columns from the PRODUCTS table (e.g., PRODUCT_ID, PRODUCT_NAME, CATEGORY, UNIT_PRICE, ACTIVE_FLAG) and re-run the optimization.
