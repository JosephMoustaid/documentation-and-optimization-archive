# Optimization report — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_LTV_RANKED

## Context
- **Execution:** exec-2026-07-11T19:30:00Z
- **Mode:** DRY_RUN
- **Result:** VALIDATED (EXPLAIN succeeded; no DDL applied)

## Original pattern
The prior definition computed rank using a correlated subquery:

```sql
(SELECT COUNT(*)
   FROM customers c2
  WHERE c2.lifetime_value > c.lifetime_value) + 1 AS ltv_rank
```

This can execute an additional aggregation per output row, which is typically expensive at scale.

## Optimization
Replaced the correlated subquery with a window function:

```sql
DENSE_RANK() OVER (ORDER BY c.lifetime_value DESC) AS ltv_rank
```

## Notes / correctness
- Produces dense ranks (ties share the same rank; next rank increments by 1).
- The original `COUNT(> value) + 1` is also dense by definition (ties share rank), so semantics are aligned.

## Recommended follow-ups
- If deterministic ordering among ties is required, add a secondary sort key (e.g., `ORDER BY lifetime_value DESC, customer_id`).
