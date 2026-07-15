# Procedure / Flow — OPT_LAB_CLONE_5.RETAIL.V_PRODUCT_REVENUE_RANK

## Execution flow (logical)
```mermaid
flowchart TD
  A[Read ORDER_ITEMS] --> B[Group by PRODUCT_ID]
  B --> C[Compute TOTAL_REVENUE = SUM(QUANTITY * UNIT_PRICE)]
  C --> D[Compute REVENUE_RANK = RANK() OVER (ORDER BY TOTAL_REVENUE DESC)]
  D --> E[Expose view V_PRODUCT_REVENUE_RANK]
```

## Applied statement
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_PRODUCT_REVENUE_RANK AS
/*
  Optimized product revenue rank view

  Optimizations:
  1) Use fully qualified table reference for ORDER_ITEMS to avoid search path dependence.
  2) Remove unnecessary subquery layer; compute aggregation directly in the main query
     and apply the window function over the aggregated result, preserving semantics
     and output schema.
*/
SELECT
    oi.product_id,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS AS oi
GROUP BY
    oi.product_id
```
