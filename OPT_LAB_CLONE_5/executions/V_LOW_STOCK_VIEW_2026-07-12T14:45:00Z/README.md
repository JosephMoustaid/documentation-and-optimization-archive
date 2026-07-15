# OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK (VIEW)

Execution: `exec-2026-07-12T14:45:00Z`

Status: `SUCCESS`  
Warehouse: `ADF_WH`  
Execution mode: `APPLY`

## Artifacts
- [schema.md](./schema.md)
- [lineage.md](./lineage.md)
- [column-lineage.md](./column-lineage.md)
- [procedure-flow.md](./procedure-flow.md)

## Change summary
The view was optimized by replacing correlated scalar subqueries with explicit `LEFT JOIN`s to `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` and `OPT_LAB_CLONE_5.RETAIL.SUPPLIERS`, and by fully qualifying referenced objects.
