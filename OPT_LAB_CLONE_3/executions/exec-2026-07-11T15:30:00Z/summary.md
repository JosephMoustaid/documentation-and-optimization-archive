# Execution Summary — exec-2026-07-11T15:30:00Z

- **Database:** OPT_LAB_CLONE_3
- **Warehouse:** ADF_WH
- **Execution mode:** DRY_RUN
- **Timestamp:** 2026-07-11T15:30:00Z
- **Overall status:** FAILED

## Results

- Total objects: 1
- Successful executions: 0
- Failed executions: 1

### Failed

1. **OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS** (VIEW)
   - Status: FAILED
   - Error: `SQL compilation error: error line 19 at position 4 invalid identifier 'C.PHONE'`
   - Note: Optimized definition referenced `C.PHONE` which does not exist in `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS`.
