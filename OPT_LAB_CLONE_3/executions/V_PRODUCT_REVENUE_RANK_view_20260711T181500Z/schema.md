# Schema — V_PRODUCT_REVENUE_RANK

Inferred from provided view DDL (not from live database introspection).

## Output columns
| Column | Type | Notes |
|---|---|---|
| PRODUCT_ID | (unknown) | From `ORDER_ITEMS.product_id` |
| TOTAL_REVENUE | (unknown) | `SUM(quantity * unit_price)` |
| REVENUE_RANK | (unknown) | `RANK() OVER (ORDER BY total_revenue DESC)` |
