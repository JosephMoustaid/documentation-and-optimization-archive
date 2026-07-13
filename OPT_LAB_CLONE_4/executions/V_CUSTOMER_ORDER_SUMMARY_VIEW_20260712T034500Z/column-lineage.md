# Column Lineage: OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

```mermaid
graph TB
  subgraph SRC_CUSTOMERS[OPT_LAB_CLONE_4.RETAIL.customers]
    c_customer_id[customer_id]
  end

  subgraph SRC_ORDERS[OPT_LAB_CLONE_4.RETAIL.orders]
    o_customer_id[customer_id]
    o_order_total[order_total]
    o_order_date[order_date]
  end

  subgraph AGG[o_agg (GROUP BY customer_id)]
    a_customer_id[customer_id]
    a_num_orders[COUNT(*) AS num_orders]
    a_total_spent[SUM(order_total) AS total_spent]
    a_last_order[MAX(order_date) AS last_order]
  end

  subgraph VIEW[OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY]
    v_customer_id[CUSTOMER_ID]
    v_num_orders[NUM_ORDERS]
    v_total_spent[TOTAL_SPENT]
    v_last_order[LAST_ORDER]
  end

  c_customer_id --> v_customer_id

  o_customer_id --> a_customer_id
  o_order_total --> a_total_spent
  o_order_date --> a_last_order
  o_customer_id --> a_num_orders

  a_num_orders --> v_num_orders
  a_total_spent --> v_total_spent
  a_last_order --> v_last_order
```

## Mapping details
- `CUSTOMER_ID` ← `customers.customer_id`
- `NUM_ORDERS` ← `COALESCE(COUNT(*), 0)` over `orders` grouped by `orders.customer_id`
- `TOTAL_SPENT` ← `SUM(orders.order_total)` grouped by `orders.customer_id`
- `LAST_ORDER` ← `MAX(orders.order_date)` grouped by `orders.customer_id`
