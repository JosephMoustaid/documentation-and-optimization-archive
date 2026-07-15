# Schema — OPT_LAB_CLONE_5.RETAIL.V_PRODUCT_REVENUE_RANK

## Object
- Database: `OPT_LAB_CLONE_5`
- Schema: `RETAIL`
- Name: `V_PRODUCT_REVENUE_RANK`
- Type: `VIEW`

## Output columns
| Ordinal | Column name | Data type | Expression |
|---:|---|---|---|
| 1 | `PRODUCT_ID` | (inherited) | `oi.product_id` |
| 2 | `TOTAL_REVENUE` | (numeric) | `SUM(oi.quantity * oi.unit_price)` |
| 3 | `REVENUE_RANK` | (numeric) | `RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC)` |

## Source relations
- `OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS` (aliased as `oi`)

## Definition (applied)
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
