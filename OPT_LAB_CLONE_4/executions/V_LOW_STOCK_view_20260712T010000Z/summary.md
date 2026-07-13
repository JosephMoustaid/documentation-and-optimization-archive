# Summary — V_LOW_STOCK (view)

- **Database:** OPT_LAB_CLONE_4
- **Schema:** RETAIL
- **Object:** V_LOW_STOCK
- **Timestamp:** 2026-07-12T01:00:00Z
- **Execution ID:** exec-2026-07-12T01:00:00Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** SUCCESS

## What changed
Replaced scalar subqueries in the SELECT list with explicit `LEFT JOIN`s to `PRODUCTS` and `SUPPLIERS`, preserving the low-stock filter (`qty_on_hand < reorder_level`) while improving readability and enabling the optimizer to plan joins more efficiently.
