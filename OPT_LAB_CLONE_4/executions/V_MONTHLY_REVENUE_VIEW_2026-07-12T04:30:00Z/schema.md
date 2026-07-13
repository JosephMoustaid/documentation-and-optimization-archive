# Schema — OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE

## Object

- **Database:** OPT_LAB_CLONE_4
- **Schema:** RETAIL
- **Name:** V_MONTHLY_REVENUE
- **Type:** VIEW

## Columns

| Column | Expression | Notes |
|---|---|---|
| ORDER_MONTH | `DATE_TRUNC('month', o.order_date)` (materialized as `order_month` in CTE) | Month bucket (timestamp/date truncated to month) |
| ORDER_COUNT | `COUNT(DISTINCT order_id)` | Distinct orders per month |
| REVENUE | `SUM(order_total)` | Sum of order totals per month |

## Source Objects

| Source | Type | Filter/Join Notes |
|---|---|---|
| OPT_LAB_CLONE_4.RETAIL.ORDERS | TABLE | Filter: `status IN ('PAID','SHIPPED')` (normalized to `('PAID', 'SHIPPED')` in optimized SQL) |

## Definition (Before)

```sql
create or replace view V_MONTHLY_REVENUE(
	ORDER_MONTH,
	ORDER_COUNT,
	REVENUE
) as
SELECT
 DATE_TRUNC('month', o.order_date) AS order_month,
 COUNT(DISTINCT o.order_id) AS order_count,
 SUM(o.order_total) AS revenue
FROM orders o
WHERE o.status IN ('PAID','SHIPPED')
GROUP BY DATE_TRUNC('month', o.order_date);
```

## Definition (Applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE AS
/*
  Optimizations:
  - Precompute DATE_TRUNC('month', o.order_date) once via a subquery to avoid redundant function evaluation.
  - Use a derived table (CTE) to keep the main aggregation simple and potentially aid the optimizer.
  - Fully qualify the ORDERS table with schema and database for clarity and stable optimization.
*/
WITH ORDER_BASE AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS order_month,
        o.order_id,
        o.order_total
    FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
    WHERE o.status IN ('PAID', 'SHIPPED')
)
SELECT
    order_month,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(order_total)        AS revenue
FROM ORDER_BASE
GROUP BY order_month;
```
