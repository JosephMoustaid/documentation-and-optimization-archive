# Optimization execution record: exec-2026-06-30T00:00:46Z

- **Execution ID:** `exec-2026-06-30T00:00:46Z`
- **Timestamp (UTC):** `2026-06-30T00:00:46Z`
- **Warehouse:** `ADF_WH`
- **Execution mode:** `APPLY`
- **Overall status:** `FAILED`
- **Totals:** 1 object (0 succeeded, 1 failed)

## Summary
An optimization attempt for the view:
- `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH`

failed at compile time because the optimized SQL referenced a sales fact table that was missing or not authorized:
- `HAFID_OPTIM_CLONE_1.PIPELINE_MART.FCT_SALES`

No object changes were successfully applied.

## Artifacts
- `execution.json` — full execution payload (including error message)
- `artifacts/opt-1.previous_definition.sql` — prior view definition captured before APPLY
- `artifacts/opt-1.executed_sql.sql` — attempted optimized SQL that failed
- `artifacts/opt-1.error.txt` — compiler error text
- `artifacts/opt-1.message.txt` — guidance message returned with failure

## Dashboard / index updates
This execution is referenced from the repository dashboards:
- `optimizations/index.json`
- `optimizations/index.md`

## Failure details (verbatim)
- **Task:** `opt-1`
- **Object:** `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_INVENTORY_HEALTH`
- **Type:** `VIEW`
- **Error:** `SQL compilation error: Object 'HAFID_OPTIM_CLONE_1.PIPELINE_MART.FCT_SALES' does not exist or not authorized.`
