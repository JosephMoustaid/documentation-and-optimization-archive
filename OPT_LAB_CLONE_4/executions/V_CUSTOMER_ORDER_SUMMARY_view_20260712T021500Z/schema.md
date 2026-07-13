# Schema / Dependencies — V_CUSTOMER_ORDER_SUMMARY

## Referenced objects

- `OPT_LAB_CLONE_4.RETAIL.customers`
- `OPT_LAB_CLONE_4.RETAIL.orders`

## Output columns

| Column | Type | Notes |
|---|---|---|
| CUSTOMER_ID | (unknown) | From `customers.customer_id` |
| NUM_ORDERS | (unknown) | `COUNT(*)` per customer, default 0 |
| TOTAL_SPENT | (unknown) | `SUM(order_total)` per customer, default 0 |
| LAST_ORDER | (unknown) | `MAX(order_date)` per customer |

> Types are not introspected in this execution; treat as best-effort documentation.
