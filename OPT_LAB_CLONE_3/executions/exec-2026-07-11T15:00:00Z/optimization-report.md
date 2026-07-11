# Optimization Report — OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Execution
- Execution ID: `exec-2026-07-11T15:00:00Z`
- Mode: `DRY_RUN`
- Status: `VALIDATED` (EXPLAIN)

## Problem in previous definition
The previous view used three correlated scalar subqueries against `orders`:
- `COUNT(*)`
- `SUM(order_total)`
- `MAX(order_date)`

This pattern typically re-scans `ORDERS` per customer row (or forces the optimizer into less efficient plans), and it obscures join/aggregation intent.

## Optimization applied
Replaced correlated subqueries with a single aggregation over `OPT_LAB_CLONE_3.RETAIL.ORDERS`:
- `GROUP BY customer_id`
- Outputs: `num_orders`, `total_spent`, `last_order`

Then `LEFT JOIN` the aggregated result back to `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS`.

## Expected benefits
- Fewer passes over `ORDERS` (single aggregate instead of 3 correlated subqueries)
- More optimizer-friendly, set-based plan
- Clearer semantics and easier maintenance

## Notes / considerations
- The optimized SQL returns NULLs for customers with no orders unless wrapped with `COALESCE`.
- Ensure column names/casing are consistent with your Snowflake configuration and naming standards.
