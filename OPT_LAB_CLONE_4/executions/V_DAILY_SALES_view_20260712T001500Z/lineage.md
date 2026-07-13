# Lineage — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

## Upstream

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias `o` / `d1`)

## Transformations

1. **Daily aggregation**
   - Group by `orders.order_date`
   - Compute `daily_total = SUM(orders.order_total)`

2. **Running total**
   - Compute running sum ordered by `order_date`

## Notes

- The **previous** definition correctly uses `SUM(SUM(order_total)) OVER (...)` which applies the window function to the aggregated daily sum.
- The **attempted optimized** definition applied the window to the base column inside a grouped query, causing compilation failure.

```mermaid
flowchart LR
  ORDERS[(RETAIL.ORDERS)] -->|group by order_date; sum(order_total)| VDS["V_DAILY_SALES"]
```
