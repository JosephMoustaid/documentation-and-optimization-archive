# Schema — OPT_LAB_CLONE_3.RETAIL.V_PRODUCT_REVENUE_RANK

## View signature (logical)
| Column | Expression | Notes |
|---|---|---|
| `PRODUCT_ID` | `oi.product_id` | From `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS` |
| `TOTAL_REVENUE` | `SUM(oi.quantity * oi.unit_price)` | Aggregated revenue per product |
| `REVENUE_RANK` | `RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC)` | Rank by revenue (ties share rank) |

## Sources
- `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS` (aliased `oi`)

## Grain
One row per `product_id`.
