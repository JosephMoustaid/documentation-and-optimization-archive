# Execution summary

- Execution id: `exec-2026-07-11T23:45:00Z`
- Timestamp: `2026-07-11T23:45:00Z`
- Warehouse: `ADF_WH`
- Mode: `APPLY`

## Object

- URN: `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`
- Type: `view`
- Result: **FAILED**

## Error

```
SQL compilation error: error line 8 at position 4 invalid identifier 'C.CUSTOMER_NAME'
```

## Next step

Replace invalid `CUSTOMERS` columns in the optimized SQL with the actual columns available in `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (e.g. `FIRST_NAME`, `LAST_NAME`, etc.) and re-run.
