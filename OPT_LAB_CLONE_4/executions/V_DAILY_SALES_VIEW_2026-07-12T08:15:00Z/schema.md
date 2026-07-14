# Schema Documentation

- **Database**: `OPT_LAB_CLONE_4`
- **Schema**: `RETAIL`
- **Object**: `V_DAILY_SALES`
- **Object Type**: `VIEW`

## Definition (Applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES AS
SELECT
    o.order_date,
    /* Daily total sales per order_date */
    SUM(o.order_total)                                         AS daily_total,
    /* Running cumulative total of daily sales over time */
    SUM(SUM(o.order_total)) OVER (
        ORDER BY o.order_date
    ) AS running_total
FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
GROUP BY
    o.order_date;
```

## Output Columns

| Column | Expression | Notes |
|---|---|---|
| `ORDER_DATE` | `o.order_date` | From `OPT_LAB_CLONE_4.RETAIL.ORDERS` |
| `DAILY_TOTAL` | `SUM(o.order_total)` | Aggregated per `order_date` |
| `RUNNING_TOTAL` | `SUM(SUM(o.order_total)) OVER (ORDER BY o.order_date)` | Running cumulative sum of daily totals |

## Source Objects

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (aliased as `o`)
