# Lineage — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Overview
`V_CUSTOMER_ORDER_SUMMARY` produces one row per customer with order count, total spend, and last order date using a single aggregated pass over `orders` joined back to `customers`.

## Object-level lineage
```mermaid
flowchart LR
  Customers[(OPT_LAB_CLONE_4.RETAIL.customers)] -->|LEFT JOIN on customer_id| V[V_CUSTOMER_ORDER_SUMMARY]
  Orders[(OPT_LAB_CLONE_4.RETAIL.orders)] -->|GROUP BY customer_id (COUNT, SUM, MAX)| V[V_CUSTOMER_ORDER_SUMMARY]
```

## Notes
- The `orders` aggregation is computed once (`GROUP BY o.customer_id`) and joined to `customers`.
- `num_orders` and `total_spent` are defaulted via `COALESCE` for customers without orders.
