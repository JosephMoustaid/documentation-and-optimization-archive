# Procedure Flow: exec-2026-07-12T03:45:00Z

```mermaid
flowchart TD
  A[Start: Optimization APPLY] --> B[Target: OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY (VIEW)]
  B --> C[Rewrite SQL: replace multiple scalar/correlated subqueries with single aggregated LEFT JOIN]
  C --> D[Execute: CREATE OR REPLACE VIEW]
  D --> E{Execution status}
  E -->|SUCCESS| F[Persist artifacts + docs]
  E -->|FAILURE| G[Capture error + persist failure artifacts]
```

## Execution summary
- **Execution ID**: `exec-2026-07-12T03:45:00Z`
- **Warehouse**: `ADF_WH`
- **Mode**: `APPLY`
- **Result**: `SUCCESS`

## Key changes
- Single aggregated `LEFT JOIN` over `orders`.
- Uses `COUNT(*)` for `num_orders`.
- Applies `COALESCE` only to `num_orders`; `total_spent` and `last_order` remain `NULL` when there are no orders.
