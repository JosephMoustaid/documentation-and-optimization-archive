# Procedure Flow — OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS

**Execution:** `exec-2026-07-12T12:15:00Z`

## Flow (logical)

```mermaid
flowchart TD
  A[Query OPT_LAB_CLONE_5.RETAIL.PRODUCTS as p] --> B{Does matching ORDER_ITEMS row exist?}
  B -->|Yes| C[Exclude product]
  B -->|No| D[Include product in view output]

  E[Correlated subquery]
  E --> F[Scan OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS as oi]
  F --> G[Predicate: oi.PRODUCT_ID = p.PRODUCT_ID]
  G --> B
```

## Applied optimization notes

- Replaced `NOT IN (SELECT ...)` with `NOT EXISTS` (NULL-safe anti-join).
- Fully qualified table references.
- Preserved output schema by selecting `p.*`.
