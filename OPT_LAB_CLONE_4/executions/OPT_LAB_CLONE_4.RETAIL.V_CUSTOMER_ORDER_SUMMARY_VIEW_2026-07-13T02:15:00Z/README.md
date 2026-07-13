# Optimization Execution Documentation

- **Execution ID:** exec-2026-07-13T02:15:00Z
- **Database:** OPT_LAB_CLONE_4
- **Object:** OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY
- **Object Type:** VIEW
- **Warehouse:** ADF_WH
- **Execution Mode:** APPLY
- **Status:** SUCCESS
- **Timestamp (reported):** 2026-07-12T02:15:00Z

## What changed
The view was optimized to compute customer order summary metrics using a single aggregated `LEFT JOIN` over `orders` rather than multiple correlated scalar subqueries.

Key behaviors:
- `num_orders`: `COALESCE(..., 0)`
- `total_spent`: `COALESCE(..., 0)`
- `last_order`: remains `NULL` when the customer has no orders

## Executed SQL
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
 c.customer_id, -- Explicit customer identifier
 COALESCE(o_agg.num_orders, 0) AS num_orders,
 COALESCE(o_agg.total_spent, 0) AS total_spent, -- Default 0 when no orders
 o_agg.last_order -- NULL when no orders (kept for semantic clarity)
FROM OPT_LAB_CLONE_4.RETAIL.customers AS c
LEFT JOIN (
 -- Single aggregation over orders instead of three correlated subqueries
 SELECT
 o.customer_id,
 COUNT() AS num_orders, -- Explicit COUNT() for per-customer order count
 SUM(o.order_total) AS total_spent, -- Total amount spent per customer
 MAX(o.order_date) AS last_order -- Most recent order date per customer
 FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
 GROUP BY o.customer_id -- One grouped pass over orders
) AS o_agg
 ON o_agg.customer_id = c.customer_id;
```

## Artifacts
- [schema.md](schema.md)
- [lineage.md](lineage.md)
- [column-lineage.md](column-lineage.md)
- [procedure-flow.md](procedure-flow.md)
