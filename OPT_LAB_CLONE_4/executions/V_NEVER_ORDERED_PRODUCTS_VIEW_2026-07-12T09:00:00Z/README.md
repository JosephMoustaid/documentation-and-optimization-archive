# Execution README — exec-2026-07-12T09:00:00Z

## Context
- Database: `OPT_LAB_CLONE_4`
- Warehouse: `ADF_WH`
- Execution mode: `APPLY`
- Overall status: `SUCCESS`

## Results
| task_id | object_urn | object_type | status |
|---|---|---|---|
| opt-1 | OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS | VIEW | SUCCESS |

## Object summary
`OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS` was updated to fix an invalid projection (`SELECT p.`) by selecting `p.*` and retaining an efficient `NOT EXISTS` anti-join.

## Artifacts
- `schema.md`
- `lineage.md`
- `column-lineage.md`
- `procedure-flow.md`
