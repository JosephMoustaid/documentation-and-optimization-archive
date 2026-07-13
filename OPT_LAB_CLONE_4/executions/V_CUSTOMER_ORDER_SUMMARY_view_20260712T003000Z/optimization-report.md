# Optimization report

## Object
- URN: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- Type: view
- Execution: `exec-2026-07-12T00:30:00Z` (APPLY)
- Status: SUCCESS

## Change summary
- Ensured the view definition uses a single aggregated subquery over `OPT_LAB_CLONE_4.RETAIL.ORDERS` joined back to `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`.
- Uses:
  - `COUNT(*)` → `num_orders`
  - `SUM(order_total)` → `total_spent`
  - `MAX(order_date)` → `last_order`

## Why it helps
- Avoids multiple correlated scalar subqueries by computing all per-customer aggregates in one grouped scan of `ORDERS`.
- Typically reduces repeated work and improves optimizer opportunities for join planning.

## Applied SQL
See `optimized.sql`.
