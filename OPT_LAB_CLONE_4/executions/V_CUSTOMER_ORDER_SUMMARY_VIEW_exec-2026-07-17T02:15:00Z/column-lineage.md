# Column lineage — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Column mapping
| Target column | Source column(s) | Transformation |
|---|---|---|
| `CUSTOMER_ID` | `customers.customer_id` | Direct projection. |
| `NUM_ORDERS` | `orders.customer_id` | `COUNT()` grouped by `orders.customer_id`, then `COALESCE(..., 0)`. |
| `TOTAL_SPENT` | `orders.order_total` | `SUM(orders.order_total)` grouped by `orders.customer_id`, then `COALESCE(..., 0)`. |
| `LAST_ORDER` | `orders.order_date` | `MAX(orders.order_date)` grouped by `orders.customer_id`. |

## Visual lineage
```mermaid
flowchart TB
  subgraph S[Sources]
    c_id[customers.customer_id]
    o_cid[orders.customer_id]
    o_total[orders.order_total]
    o_date[orders.order_date]
  end

  subgraph A[Aggregation (orders GROUP BY customer_id)]
    a_num[COUNT() AS num_orders]
    a_sum[SUM(order_total) AS total_spent]
    a_max[MAX(order_date) AS last_order]
  end

  subgraph T[Target view columns]
    t_cid[CUSTOMER_ID]
    t_num[NUM_ORDERS]
    t_spent[TOTAL_SPENT]
    t_last[LAST_ORDER]
  end

  c_id --> t_cid
  o_cid --> a_num
  o_total --> a_sum
  o_date --> a_max

  a_num -->|COALESCE(…,0)| t_num
  a_sum -->|COALESCE(…,0)| t_spent
  a_max --> t_last
```
