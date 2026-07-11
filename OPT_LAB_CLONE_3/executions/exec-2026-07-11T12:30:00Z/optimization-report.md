# Optimization report — OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Context

- **Execution ID:** exec-2026-07-11T12:30:00Z
- **Mode:** DRY_RUN (validated via EXPLAIN; no DDL applied)
- **Object:** OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY (VIEW)

## What changed

### Before
The view computed `num_orders`, `total_spent`, and `last_order` using **three correlated subqueries** against `orders` for every row in `customers`.

### After
The view replaces correlated subqueries with a **single aggregated subquery** over `ORDERS` grouped by `CUSTOMER_ID`, then **LEFT JOINs** the result to `CUSTOMERS`.

- Aggregations calculated once per customer:
  - `COUNT(*) AS num_orders`
  - `SUM(ORDER_TOTAL) AS total_spent`
  - `MAX(ORDER_DATE) AS last_order`
- `COALESCE(..., 0)` used for numeric aggregates to keep customers with no orders at 0.

## Why this is better

- Avoids repeated scans of `ORDERS` (3 correlated subqueries) and replaces them with one grouped scan.
- Typically improves performance by enabling the optimizer to:
  - pre-aggregate `ORDERS`
  - execute a hash join/merge join to `CUSTOMERS`
  - reduce per-row subquery overhead

## Behavioral considerations

- **Row preservation:** uses `LEFT JOIN` so all customers remain present.
- **Null-handling:** `NUM_ORDERS` and `TOTAL_SPENT` become 0 instead of NULL for customers with no orders.
- **Column set:** still returns `c.*` plus derived order metrics.

## Validation

- Status: **VALIDATED**
- Validation method: EXPLAIN (DRY_RUN)
- No changes applied to the live view.

## Recommended follow-ups

- Consider explicitly listing customer columns instead of `c.*` for schema stability.
- Ensure `ORDERS.CUSTOMER_ID` is clustered/indexed appropriately for join + aggregation efficiency.

