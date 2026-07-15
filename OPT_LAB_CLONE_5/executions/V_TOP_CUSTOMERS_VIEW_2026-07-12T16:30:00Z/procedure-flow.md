# Procedure Flow — Optimization APPLY

- **Execution:** exec-2026-07-12T16:30:00Z
- **Object:** OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS (VIEW)

```mermaid
flowchart TD
  A[Start: exec-2026-07-12T16:30:00Z] --> B[Load previous view definition]
  B --> C[Identify correlated subquery counting returned orders]
  C --> D[Rewrite to pre-aggregate ORDERS by customer_id]
  D --> E[LEFT JOIN aggregated results into V_CUSTOMER_ORDER_SUMMARY]
  E --> F[Preserve filters and ordering: total_spent > 0, ORDER BY total_spent DESC]
  F --> G[APPLY: CREATE OR REPLACE VIEW]
  G --> H[Status: SUCCESS]
```

## Change detail
- **Before:** per-row correlated subquery:
  - `SELECT COUNT(*) FROM orders o WHERE o.customer_id = s.customer_id AND o.status='RETURNED'`
- **After:** single aggregation + join:
  - Aggregate `ORDERS` once: `GROUP BY o.customer_id` with `WHERE o.status='RETURNED'`
  - Join on `customer_id`
