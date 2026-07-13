# Optimization report

## Execution
- **Execution ID:** exec-2026-07-13T02:15:00Z
- **Payload timestamp:** 2026-07-12T02:15:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY

## Object
- **Object:** OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY
- **Type:** view
- **Status:** SUCCESS

## Optimization summary
1. **Aggregation strategy**: Uses a single grouped aggregation over `orders` (grouped by `customer_id`) and joins it once to `customers`. This avoids repeated scans typical of multiple scalar subqueries.
2. **Null-handling / semantics**:
   - `num_orders` remains `0` when no orders via `COALESCE`.
   - `total_spent` changed to default to `0` when no orders (`COALESCE(o_agg.total_spent, 0)`), whereas previously it could be `NULL`.
   - `last_order` remains `NULL` when no orders.

## Notes / validation ideas
- If downstream logic relies on `TOTAL_SPENT IS NULL` to detect no-order customers, it should be updated to use `NUM_ORDERS = 0` (or a separate flag).
- Compare row counts between previous and optimized view: should match `customers` cardinality.
- Spot-check customers with no orders: `NUM_ORDERS=0`, `TOTAL_SPENT=0`, `LAST_ORDER=NULL`.
