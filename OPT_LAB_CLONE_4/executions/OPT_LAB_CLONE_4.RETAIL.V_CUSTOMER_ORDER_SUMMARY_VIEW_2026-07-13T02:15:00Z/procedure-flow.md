# Procedure / Query Flow

This view computes customer-level order metrics by joining `customers` to an aggregated subquery over `orders`.

```mermaid
flowchart TD
  S[Start] --> C[Scan customers c]
  C --> O[Scan orders o]
  O --> G[Aggregate orders by customer_id\nCOUNT(), SUM(order_total), MAX(order_date)]
  G --> J[LEFT JOIN customers to aggregated orders on customer_id]
  J --> P[Project columns\ncustomer_id, COALESCE(num_orders,0), COALESCE(total_spent,0), last_order]
  P --> E[End]
```
