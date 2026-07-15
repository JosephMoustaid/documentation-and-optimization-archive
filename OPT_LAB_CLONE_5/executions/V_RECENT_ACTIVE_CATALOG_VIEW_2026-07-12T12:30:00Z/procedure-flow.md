# Procedure / Flow

Although this is a VIEW (not a stored procedure), the logical execution can be represented as a flow.

```mermaid
flowchart TD
  A[Start: Query V_RECENT_ACTIVE_CATALOG] --> B[Read PRODUCTS as p]
  B --> C[Filter p.active_flag = TRUE]
  C --> D[Filter p.category COLLATE "en-ci" = 'ELECTRONICS']
  D --> E[Read INVENTORY as i]
  E --> F[Filter i.last_restocked in current year (half-open range)]
  F --> G[Join i to p on product_id]
  G --> H[Project columns: product_id, product_name, category, unit_price]
  H --> I[Return result set]
```

## Execution semantics
- Filters on `PRODUCTS` and `INVENTORY` are applied before/around the join as chosen by the optimizer.
- The date-range predicate is sargable and is typically more amenable to partition pruning than `YEAR(last_restocked) = YEAR(CURRENT_DATE)`.
