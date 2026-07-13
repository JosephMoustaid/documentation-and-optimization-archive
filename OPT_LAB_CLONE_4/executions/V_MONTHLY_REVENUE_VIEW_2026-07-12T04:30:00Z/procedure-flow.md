# Procedure / Query Flow — OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE

## Logical Flow

```mermaid
flowchart TD
  A[Read OPT_LAB_CLONE_4.RETAIL.ORDERS] --> B[Filter status IN ('PAID','SHIPPED')]
  B --> C[CTE ORDER_BASE: compute order_month = DATE_TRUNC('month', order_date)]
  C --> D[Aggregate by order_month]
  D --> E[Compute order_count = COUNT(DISTINCT order_id)]
  D --> F[Compute revenue = SUM(order_total)]
  E --> G[Output rows]
  F --> G
```

## Optimization Notes

- The applied definition computes `order_month` once in `ORDER_BASE` rather than repeating `DATE_TRUNC` in both `SELECT` and `GROUP BY`.
- Fully qualified reference: `OPT_LAB_CLONE_4.RETAIL.orders`.
