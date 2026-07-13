# OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES — Execution Summary

- **Execution ID:** exec-2026-07-12T00:15:00Z
- **Timestamp:** 2026-07-12T00:15:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Object:** OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES (view)
- **Status:** FAILED

## Failure

- **Error:** `SQL compilation error: [D1.ORDER_TOTAL] is not a valid group by expression`
- **Cause:** The attempted optimized definition mixes `GROUP BY d1.order_date` with a window expression over the non-grouped base column `d1.order_total`.
- **Fix:** Aggregate per-day in a subquery/CTE, then apply the running total window over the aggregated `daily_total`.

## Files

- `previous.sql` — prior view definition
- `optimized.sql` — attempted definition that failed in APPLY
- `optimization-report.md` — recommendations and a corrected template
- `schema.md`, `lineage.md`, `column-lineage.md` — inferred documentation
