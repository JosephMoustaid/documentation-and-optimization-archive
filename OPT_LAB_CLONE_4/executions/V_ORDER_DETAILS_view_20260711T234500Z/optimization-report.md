# Optimization report

## Execution

- Execution id: `exec-2026-07-11T23:45:00Z`
- Timestamp: `2026-07-11T23:45:00Z`
- Warehouse: `ADF_WH`
- Mode: `APPLY`

## Object

- URN: `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`
- Type: `view`

## Result

**FAILED**

## Error

```
SQL compilation error: error line 8 at position 4 invalid identifier 'C.CUSTOMER_NAME'
```

## Root cause

The attempted optimized view definition explicitly referenced `CUSTOMERS` columns that are not present in `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`.

## Impact

- The view was not replaced/updated by this execution.
- Any downstream objects depending on the view are unaffected by this APPLY attempt.

## Recommended remediation

1. Inspect `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` schema.
2. Replace invalid references (`CUSTOMER_NAME`, `PHONE`, `ADDRESS`) with valid columns (commonly `FIRST_NAME`, `LAST_NAME`, etc.).
3. Re-run in APPLY mode.

## SQL

See:

- `previous.sql`
- `optimized.sql`
