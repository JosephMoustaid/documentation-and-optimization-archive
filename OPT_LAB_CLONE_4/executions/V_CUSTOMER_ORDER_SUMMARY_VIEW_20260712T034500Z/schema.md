# Schema: OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Object
- **Database**: `OPT_LAB_CLONE_4`
- **Schema**: `RETAIL`
- **Name**: `V_CUSTOMER_ORDER_SUMMARY`
- **Type**: `VIEW`

## Definition (applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
    c.customer_id,                                  -- Explicit customer identifier
    COALESCE(o_agg.num_orders, 0) AS num_orders,    -- 0 when no orders
    o_agg.total_spent,                              -- NULL when no orders
    o_agg.last_order                                -- NULL when no orders
FROM OPT_LAB_CLONE_4.RETAIL.customers AS c
LEFT JOIN (
    -- Single aggregation over orders instead of multiple scalar subqueries
    SELECT
        o.customer_id,
        COUNT(*)              AS num_orders,
        SUM(o.order_total)    AS total_spent,
        MAX(o.order_date)     AS last_order
    FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
    GROUP BY o.customer_id
) AS o_agg
    ON o_agg.customer_id = c.customer_id;
```

## Output columns
| Ordinal | Column | Type | Notes |
|---:|---|---|---|
| 1 | CUSTOMER_ID | (inherited) | From `customers.customer_id` |
| 2 | NUM_ORDERS | NUMBER | `COALESCE(o_agg.num_orders, 0)` |
| 3 | TOTAL_SPENT | NUMBER | `SUM(orders.order_total)` (NULL if no orders) |
| 4 | LAST_ORDER | DATE/TIMESTAMP | `MAX(orders.order_date)` (NULL if no orders) |

## Source objects
- `OPT_LAB_CLONE_4.RETAIL.customers`
- `OPT_LAB_CLONE_4.RETAIL.orders`
