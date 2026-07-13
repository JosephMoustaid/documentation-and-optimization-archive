# Schema — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

- **Database:** OPT_LAB_CLONE_4
- **Schema:** RETAIL
- **Object:** V_DAILY_SALES
- **Type:** VIEW
- **Execution ID:** exec-2026-07-12T04:00:00Z
- **Warehouse:** ADF_WH
- **Execution Mode:** APPLY
- **Status:** SUCCESS
- **Timestamp:** 2026-07-12T04:00:00Z

## Columns

| Ordinal | Column | Data Type | Nullable | Source / Derivation |
|---:|---|---|---|---|
| 1 | ORDER_DATE | (inferred) | (unknown) | `o.order_date` (grouping key) |
| 2 | DAILY_TOTAL | (inferred) | (unknown) | `SUM(o.order_total)` aggregated by `order_date` |
| 3 | RUNNING_TOTAL | (inferred) | (unknown) | `SUM(daily_total) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` |

## Definition (Applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES AS
/*
  Optimizations:
  - Use a derived table to perform the aggregation once, then apply the
    window function on the aggregated result set. This avoids redundant
    SUM(SUM(...)) and makes the intent clearer to the optimizer.
  - Keep ordering of the running total explicit on order_date.
*/
WITH daily_agg AS (
    SELECT
        o.order_date,
        SUM(o.order_total) AS daily_total
    FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
    GROUP BY
        o.order_date
)
SELECT
    order_date,
    daily_total,
    SUM(daily_total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM daily_agg;
```
