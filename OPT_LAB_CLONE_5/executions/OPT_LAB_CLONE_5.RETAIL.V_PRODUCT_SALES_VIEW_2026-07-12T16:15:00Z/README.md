# Execution documentation — exec-2026-07-12T16:15:00Z

**Database**: `OPT_LAB_CLONE_5`  
**Warehouse**: `ADF_WH`  
**Mode**: `APPLY`  
**Overall status**: `SUCCESS`

## Object

- URN: `OPT_LAB_CLONE_5.RETAIL.V_PRODUCT_SALES`
- Type: `VIEW`
- Schema: `RETAIL`

## Result

- Status: `SUCCESS`
- Optimization: removed `DISTINCT`; fully qualified base tables.

## Files

- `schema.md` — output schema and base relations
- `lineage.md` — object lineage + Mermaid
- `column-lineage.md` — column mappings + Mermaid
- `procedure-flow.md` — apply flow + executed SQL + Mermaid
