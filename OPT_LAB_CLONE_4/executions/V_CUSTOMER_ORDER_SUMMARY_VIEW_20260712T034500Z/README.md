# Execution: exec-2026-07-12T03:45:00Z

## Overview
- **Database**: `OPT_LAB_CLONE_4`
- **Object**: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Object type**: `VIEW`
- **Warehouse**: `ADF_WH`
- **Mode**: `APPLY`
- **Status**: `SUCCESS`

## What changed
The view was optimized to compute order aggregates in a single grouped pass over `orders` and `LEFT JOIN` them to `customers`.

## Files in this folder
- `schema.md` — view definition and outputs
- `lineage.md` — object-level lineage (Mermaid)
- `column-lineage.md` — column-level lineage (Mermaid)
- `procedure-flow.md` — execution flow (Mermaid)
- `artifacts/execution-request.json` — request payload
- `artifacts/execution-metadata.json` — metadata
- `artifacts/execution-results.json` — per-object results and SQL
- `artifacts/previous-definition.sql` — prior definition
- `artifacts/executed.sql` — applied SQL
