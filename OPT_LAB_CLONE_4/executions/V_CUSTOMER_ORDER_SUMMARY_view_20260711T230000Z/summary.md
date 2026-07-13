# Execution Summary

- **Execution ID:** exec-2026-07-11T23:00:00Z
- **Timestamp (UTC):** 2026-07-11T23:00:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY` (view)
- **Status:** FAILED

## Failure details

- **Error:** `SQL compilation error: error line 4 at position 4 invalid identifier 'C.CUSTOMER_NAME'`
- **Meaning:** The optimized view definition referenced one or more columns (e.g., `c.customer_name`) that do **not** exist in `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`.

## Recommended fix (do not alter business logic)

Update the optimized SQL to select/group by only valid `CUSTOMERS` columns (e.g., `CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, ...`) and re-run optimization.