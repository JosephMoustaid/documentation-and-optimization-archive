# Output schema (inferred) — V_CUSTOMER_ORDER_SUMMARY

**View:** `OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

The view selects `c.*` from `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` plus three derived columns.

## Columns

### From `CUSTOMERS` (`c.*`)
All columns from `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` are projected as-is.

### Derived / appended
| Column | Expression | Notes |
|---|---|---|
| `NUM_ORDERS` | `COALESCE(o_agg.num_orders, 0)` | Count of orders per customer (0 when none) |
| `TOTAL_SPENT` | `COALESCE(o_agg.total_spent, 0)` | Sum of `order_total` per customer (0 when none) |
| `LAST_ORDER` | `o_agg.last_order` | Max `order_date` per customer (NULL when none) |

> Column types for the derived columns follow the underlying aggregate expressions in Snowflake.
