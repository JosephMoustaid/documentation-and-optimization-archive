# Column lineage: OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE

```mermaid
flowchart LR
  subgraph SRC[OPT_LAB_CLONE_4.RETAIL.ORDERS]
    o_order_date[order_date]
    o_order_id[order_id]
    o_order_total[order_total]
    o_status[status]
  end

  subgraph TGT[OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE]
    v_order_month[ORDER_MONTH]
    v_order_count[ORDER_COUNT]
    v_revenue[REVENUE]
  end

  o_order_date -->|DATE_TRUNC('month', ...)| v_order_month
  o_order_id -->|COUNT(DISTINCT ...)| v_order_count
  o_order_total -->|SUM(...)| v_revenue
  o_status -.->|FILTER status IN ('PAID','SHIPPED')| v_order_count
  o_status -.->|FILTER status IN ('PAID','SHIPPED')| v_revenue
  o_status -.->|FILTER status IN ('PAID','SHIPPED')| v_order_month
```

## Mapping details

| Target column | Source(s) | Transformation |
|---|---|---|
| `ORDER_MONTH` | `ORDERS.order_date` | `DATE_TRUNC('month', order_date)` |
| `ORDER_COUNT` | `ORDERS.order_id` | `COUNT(DISTINCT order_id)` with `status IN ('PAID','SHIPPED')` |
| `REVENUE` | `ORDERS.order_total` | `SUM(order_total)` with `status IN ('PAID','SHIPPED')` |
