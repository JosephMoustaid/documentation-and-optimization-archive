# Column Lineage — OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS

- **Execution:** exec-2026-07-12T16:30:00Z

## Column mapping
| Target column | Source expression | Upstream objects |
|---|---|---|
| customer_id | `s.customer_id` | `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| first_name | `s.first_name` | `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| last_name | `s.last_name` | `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| total_spent | `s.total_spent` | `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| returned_orders | `COUNT(*)` over `OPT_LAB_CLONE_5.RETAIL.ORDERS` where `status='RETURNED'` grouped by `o.customer_id` | `OPT_LAB_CLONE_5.RETAIL.ORDERS` |

## Diagram
```mermaid
flowchart TB
  subgraph VSUM[OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY (alias s)]
    s_cust[customer_id]
    s_fn[first_name]
    s_ln[last_name]
    s_ts[total_spent]
  end

  subgraph ORD[OPT_LAB_CLONE_5.RETAIL.ORDERS (alias o)]
    o_cust[customer_id]
    o_status[status]
    o_rows[(rows)]
  end

  subgraph VTOP[OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS]
    v_cust[customer_id]
    v_fn[first_name]
    v_ln[last_name]
    v_ts[total_spent]
    v_ret[returned_orders]
  end

  s_cust --> v_cust
  s_fn --> v_fn
  s_ln --> v_ln
  s_ts --> v_ts

  o_cust --> agg["GROUP BY customer_id\nCOUNT(*) AS returned_orders\nWHERE status='RETURNED'"]
  o_status --> agg
  o_rows --> agg
  agg --> v_ret
```

## Join semantics
- `LEFT JOIN` on `customer_id` between summary (`s`) and aggregated returns ensures all qualifying customers are retained.
- `returned_orders` may be NULL when no returned orders exist for a customer.
