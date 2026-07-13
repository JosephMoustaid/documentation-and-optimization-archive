# Column Lineage

## Target: `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`

| Target column | Expression | Upstream columns |
|---|---|---|
| `CUSTOMER_ID` | `c.customer_id` | `customers.customer_id` |
| `NUM_ORDERS` | `COALESCE(o_agg.num_orders, 0)` where `o_agg.num_orders = COUNT()` | `orders.customer_id` (group key) |
| `TOTAL_SPENT` | `COALESCE(o_agg.total_spent, 0)` where `o_agg.total_spent = SUM(o.order_total)` | `orders.order_total`, `orders.customer_id` (group key) |
| `LAST_ORDER` | `o_agg.last_order` where `o_agg.last_order = MAX(o.order_date)` | `orders.order_date`, `orders.customer_id` (group key) |

```mermaid
flowchart TB
  customers_customer_id[customers.customer_id] --> v_customer_id[V_CUSTOMER_ORDER_SUMMARY.CUSTOMER_ID]

  orders_customer_id[orders.customer_id] --> agg_group[GROUP BY customer_id]
  agg_group --> count_num_orders[COUNT()] --> v_num_orders[NUM_ORDERS]

  orders_order_total[orders.order_total] --> sum_total_spent[SUM(order_total)] --> v_total_spent[TOTAL_SPENT]

  orders_order_date[orders.order_date] --> max_last_order[MAX(order_date)] --> v_last_order[LAST_ORDER]
```
