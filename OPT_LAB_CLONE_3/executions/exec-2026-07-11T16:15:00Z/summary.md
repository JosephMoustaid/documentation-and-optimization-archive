# Execution Summary — exec-2026-07-11T16:15:00Z

- Database: `OPT_LAB_CLONE_3`
- Warehouse: `ADF_WH`
- Mode: `DRY_RUN`
- Status: `FAILED`
- Timestamp: `2026-07-11T16:15:00Z`

## Results

- Total objects: 1
- Successful: 0
- Failed: 1

### Failed object

- Object: `OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS` (VIEW)
- Task: `opt-1`
- Error: `SQL compilation error: invalid identifier 'C.PHONE'`
- Detail: Optimized view references a column that does not exist in `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS`. Remove/correct the invalid column(s) and re-run validation.
