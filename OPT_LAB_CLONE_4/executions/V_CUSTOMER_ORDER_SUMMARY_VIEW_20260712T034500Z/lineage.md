# Lineage: OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

```mermaid
graph LR
  V["VIEW\nOPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY"]

  C["TABLE\nOPT_LAB_CLONE_4.RETAIL.customers"]
  O["TABLE\nOPT_LAB_CLONE_4.RETAIL.orders"]

  C --> V
  O --> V
```

## Notes
- The view reads all customers and left-joins a single aggregated subquery over orders.
- Aggregation is performed once per `customer_id` in `orders`.
