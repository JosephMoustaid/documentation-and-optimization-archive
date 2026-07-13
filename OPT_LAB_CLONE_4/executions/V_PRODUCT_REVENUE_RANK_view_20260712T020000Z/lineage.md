# Lineage — V_PRODUCT_REVENUE_RANK

## Object lineage

- **Target view**: `OPT_LAB_CLONE_4.RETAIL.V_PRODUCT_REVENUE_RANK`
  - **Reads from**: `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS`

## Transform summary
- Aggregates order item revenue per `PRODUCT_ID` using `SUM(QUANTITY * UNIT_PRICE)`.
- Produces a revenue rank using `RANK()` over descending total revenue.
