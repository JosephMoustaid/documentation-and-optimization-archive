# Procedure / Flow: OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE

```mermaid
flowchart TD
  A[Start] --> B[Read OPT_LAB_CLONE_4.RETAIL.ORDERS]
  B --> C[Filter: status IN ('PAID','SHIPPED')]
  C --> D[Derive: order_month = DATE_TRUNC('month', order_date)]
  D --> E[Group by: order_month]
  E --> F[Aggregate: COUNT(DISTINCT order_id) as order_count]
  E --> G[Aggregate: SUM(order_total) as revenue]
  F --> H[Output view rows]
  G --> H
  H --> I[End]
```

## Applied optimization notes

- Fully qualified source reference: `OPT_LAB_CLONE_4.RETAIL.orders`
- Grouping uses the `order_month` alias to avoid repeating the `DATE_TRUNC` expression
