```mermaid
flowchart LR
  C[(OPT_LAB_CLONE_4.RETAIL.CUSTOMERS)] --> V[OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY]
  O[(OPT_LAB_CLONE_4.RETAIL.ORDERS)] --> V
```

## Notes

- Previous definition joins `CUSTOMERS` to an aggregated derived table over `ORDERS`.
- Optimized (attempted) definition joins `CUSTOMERS` to `ORDERS` directly and aggregates with `GROUP BY`. APPLY failed due to invalid column reference.