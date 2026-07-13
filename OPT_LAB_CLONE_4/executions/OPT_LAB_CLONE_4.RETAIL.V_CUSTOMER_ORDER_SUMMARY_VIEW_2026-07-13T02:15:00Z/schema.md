# Schema (logical)

## Target object
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Type:** `VIEW`

## Output columns
| Column | Type | Notes |
|---|---|---|
| `CUSTOMER_ID` | (inherited) | From `customers.customer_id` |
| `NUM_ORDERS` | (derived) | `COALESCE(COUNT(), 0)` from aggregated orders |
| `TOTAL_SPENT` | (derived) | `COALESCE(SUM(order_total), 0)` from aggregated orders |
| `LAST_ORDER` | (derived) | `MAX(order_date)` from aggregated orders; NULL when no orders |

## Sources
- `OPT_LAB_CLONE_4.RETAIL.customers`
- `OPT_LAB_CLONE_4.RETAIL.orders`
