# Execution: exec-2026-07-17T02:15:00Z

- **Database**: `OPT_LAB_CLONE_4`
- **Object**: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Type**: `VIEW`
- **Warehouse**: `ADF_WH`
- **Mode**: `APPLY`
- **Status**: `SUCCESS`
- **Task**: `opt-1`
- **Execution timestamp**: `2026-07-12T02:15:00Z`

## Summary
This execution applied an optimization to `V_CUSTOMER_ORDER_SUMMARY` by using a single aggregated `LEFT JOIN` over `orders` (instead of multiple scalar subqueries) and by defaulting `total_spent` to `0` when a customer has no orders.

## What changed
- `total_spent`: `COALESCE(o_agg.total_spent, 0)` (previously could be `NULL` when no orders)
- Aggregation: consolidated to a single grouped pass over `OPT_LAB_CLONE_4.RETAIL.orders`
- `last_order`: kept as `NULL` when no orders for semantic clarity

## Artifacts
- [schema.md](./schema.md)
- [lineage.md](./lineage.md)
- [column-lineage.md](./column-lineage.md)
- [procedure-flow.md](./procedure-flow.md)
