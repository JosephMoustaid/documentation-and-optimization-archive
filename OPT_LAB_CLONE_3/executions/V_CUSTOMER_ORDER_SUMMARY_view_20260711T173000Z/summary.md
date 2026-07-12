# Summary — V_CUSTOMER_ORDER_SUMMARY (view)

- **Object URN:** `OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Execution ID:** `exec-2026-07-11T17:30:00Z`
- **Timestamp:** `2026-07-11T17:30:00Z`
- **Warehouse:** `ADF_WH`
- **Mode:** `DRY_RUN`
- **Result:** `VALIDATED` (EXPLAIN succeeded; no changes applied)

## What this view does
Enriches each row from `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` with order-level aggregates from `OPT_LAB_CLONE_3.RETAIL.ORDERS`:

- `NUM_ORDERS`: count of orders per customer
- `TOTAL_SPENT`: sum of `ORDER_TOTAL` per customer
- `LAST_ORDER`: max `ORDER_DATE` per customer

## Optimization applied
Replaced three correlated scalar subqueries over `ORDERS` with a single aggregated subquery grouped by `CUSTOMER_ID`, joined back to `CUSTOMERS`.

## Expected impact
- Avoids repeated rescans of `ORDERS` per customer row.
- Enables the optimizer to compute aggregates once and reuse them via the join.
