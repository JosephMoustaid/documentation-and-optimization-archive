# Optimization report — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

- **Execution:** exec-2026-07-12T02:15:00Z
- **Status:** SUCCESS

## Original pattern
The prior definition already used an aggregated derived table (`o_agg`) joined to `customers`, eliminating correlated scalar subqueries.

## Applied changes
- Kept the single-pass aggregated `LEFT JOIN` strategy over `orders`.
- Ensured numeric measures default predictably:
  - `num_orders`: `COALESCE(..., 0)`
  - `total_spent`: `COALESCE(..., 0)` (changed from nullable)
- Preserved semantic clarity by keeping `last_order` nullable when no orders.

## Notes / considerations
- If downstream consumers relied on `TOTAL_SPENT` being `NULL` when there are no orders, this change may be semantically breaking. Consider whether `0` is the intended business meaning.
