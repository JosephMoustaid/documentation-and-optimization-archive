# Schema: OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE

## Object

- Database: `OPT_LAB_CLONE_4`
- Schema: `RETAIL`
- Name: `V_MONTHLY_REVENUE`
- Type: `VIEW`

## Definition (applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE AS
/*
  Optimized view: V_MONTHLY_REVENUE
  Optimizations:
  - Fully qualified table reference to avoid search path ambiguity.
  - Single computation of DATE_TRUNC('month', o.order_date) using a SELECT alias,
    then grouping by that alias for clarity (Snowflake allows this) and to avoid
    duplicating the expression.
  - Preserved existing business logic: monthly aggregation of orders with status
    constrained to PAID/SHIPPED, distinct order count, and total revenue.
*/
SELECT
    DATE_TRUNC('month', o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id)      AS order_count,
    SUM(o.order_total)             AS revenue
FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
WHERE o.status IN ('PAID','SHIPPED')
GROUP BY order_month;
```

## Columns

| Column | Type | Expression | Notes |
|---|---|---|---|
| `ORDER_MONTH` | (inferred) | `DATE_TRUNC('month', o.order_date)` | Month bucket for `order_date`. |
| `ORDER_COUNT` | (inferred) | `COUNT(DISTINCT o.order_id)` | Distinct count of orders in the month. |
| `REVENUE` | (inferred) | `SUM(o.order_total)` | Total revenue for orders in the month. |

## Source tables

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (aliased as `o`)
