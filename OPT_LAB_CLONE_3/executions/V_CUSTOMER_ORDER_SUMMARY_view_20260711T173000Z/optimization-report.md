# Optimization report — V_CUSTOMER_ORDER_SUMMARY (view)

- **Object:** `OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Execution ID:** `exec-2026-07-11T17:30:00Z`
- **Timestamp:** `2026-07-11T17:30:00Z`
- **Mode:** `DRY_RUN`
- **Validation:** `VALIDATED` (via EXPLAIN)

## Before
Pattern: correlated scalar subqueries per customer row:
- `COUNT(*)` from `ORDERS` filtered by `o.customer_id = c.customer_id`
- `SUM(order_total)` with the same correlation
- `MAX(order_date)` with the same correlation

This can cause repeated scans/aggregation of `ORDERS` for each row in `CUSTOMERS`.

## After
Rewrite to a single aggregated derived table:
- Aggregate `ORDERS` once: `GROUP BY customer_id`
- Join to `CUSTOMERS` using `LEFT JOIN`
- Use `COALESCE` to default numeric aggregates to 0

## Semantic equivalence notes
- `LEFT JOIN` preserves all customers.
- Customers with no orders produce NULL aggregates; `COALESCE` yields 0 for `NUM_ORDERS` and `TOTAL_SPENT`.
- `LAST_ORDER` remains NULL when no orders exist.

## Operational notes
- DRY_RUN mode: the optimized DDL was validated but **not applied**.
