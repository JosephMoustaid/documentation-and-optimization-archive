# OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS (view)

Execution folder: `V_ORDER_DETAILS_view_20260711T234500Z`  
Execution id: `exec-2026-07-11T23:45:00Z`  
Timestamp: `2026-07-11T23:45:00Z`  
Mode: `APPLY`  
Warehouse: `ADF_WH`

## Status

**FAILED**

Error:

```
SQL compilation error: error line 8 at position 4 invalid identifier 'C.CUSTOMER_NAME'
```

## What happened

The attempted optimized view definition enumerated customer columns that do not exist in `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (e.g. `CUSTOMER_NAME`, `PHONE`, `ADDRESS`).

## Recommended fix

Update the SELECT list to include only valid columns from `CUSTOMERS` (e.g. `CUSTOMER_ID`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`, etc.), then re-run the APPLY.

## Files

- `execution.json` — full execution payload
- `previous.sql` — previous view definition
- `optimized.sql` — attempted optimized SQL that failed to compile
- `summary.md` — brief result summary
- `optimization-report.md` — detailed optimization/failure report
- `schema.md` — output column list (from previous view DDL)
- `lineage.md` — object-level lineage
- `column-lineage.md` — column-level lineage (best-effort)
