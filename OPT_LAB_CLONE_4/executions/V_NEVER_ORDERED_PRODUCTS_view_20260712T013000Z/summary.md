# Execution Summary

- **Database:** OPT_LAB_CLONE_4
- **Warehouse:** ADF_WH
- **Execution ID:** exec-2026-07-12T01:30:00Z
- **Timestamp:** 2026-07-12T01:30:00Z
- **Mode:** APPLY
- **Overall Status:** FAILED

## Object Result

- **Object URN:** OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS
- **Object Type:** VIEW
- **Status:** FAILED
- **Error:** SQL compilation error: error line 6 at position 4 invalid identifier 'P.PRICE'

### Notes
The optimized view definition referenced non-existent columns in `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (for example `P.PRICE` and `P.ACTIVE`). Update the SELECT list to use valid columns (e.g., `PRODUCT_ID`, `PRODUCT_NAME`, `CATEGORY`, `UNIT_PRICE`, `ACTIVE_FLAG`) and rerun.
