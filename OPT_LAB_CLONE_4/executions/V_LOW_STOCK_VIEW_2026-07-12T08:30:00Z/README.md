# Execution documentation

- **Execution ID**: `exec-2026-07-12T08:30:00Z`
- **Timestamp**: `2026-07-12T08:30:00Z`
- **Warehouse**: `ADF_WH`
- **Mode**: `APPLY`
- **Status**: `SUCCESS`

## Object
- `OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK` (VIEW)

## Result
Applied optimization successfully:
- Replaced scalar subqueries with fully qualified `LEFT JOIN`s to `PRODUCTS` and `SUPPLIERS`.
- Preserved predicate: `i.qty_on_hand < i.reorder_level`.

## Artifacts
- `schema.md`
- `lineage.md`
- `column-lineage.md`
- `procedure-flow.md`
