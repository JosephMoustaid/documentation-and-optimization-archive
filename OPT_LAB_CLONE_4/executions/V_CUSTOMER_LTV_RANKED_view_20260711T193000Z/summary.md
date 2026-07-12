# Summary — V_CUSTOMER_LTV_RANKED (view)

- **Database.Schema.Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_LTV_RANKED`
- **Execution:** `exec-2026-07-11T19:30:00Z`
- **Mode:** `DRY_RUN`
- **Status:** `VALIDATED` (no changes applied)

## What changed
Replaced a correlated subquery used to compute rank with an analytic window function:
- From: `COUNT(*) ... WHERE c2.lifetime_value > c.lifetime_value) + 1`
- To: `DENSE_RANK() OVER (ORDER BY c.lifetime_value DESC)`

## Expected impact
- Eliminates per-row correlated aggregation.
- Enables set-based ranking and typically improves scalability on large `customers`.
