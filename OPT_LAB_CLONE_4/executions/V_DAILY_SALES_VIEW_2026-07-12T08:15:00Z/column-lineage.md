# Column Lineage

- **Target**: `OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES`

## Column Mapping

| Target Column | Source Column(s) | Derivation |
|---|---|---|
| `ORDER_DATE` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.ORDER_DATE` | Direct passthrough (`o.order_date`) |
| `DAILY_TOTAL` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.ORDER_TOTAL` | `SUM(o.order_total)` grouped by `o.order_date` |
| `RUNNING_TOTAL` | `OPT_LAB_CLONE_4.RETAIL.ORDERS.ORDER_TOTAL` | `SUM(SUM(o.order_total)) OVER (ORDER BY o.order_date)` (running cumulative sum of daily totals) |

```mermaid
flowchart LR
  subgraph SRC["OPT_LAB_CLONE_4.RETAIL.ORDERS"]
    ORD_ORDER_DATE["ORDER_DATE"]
    ORD_ORDER_TOTAL["ORDER_TOTAL"]
  end

  subgraph TGT["OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES"]
    V_ORDER_DATE["ORDER_DATE"]
    V_DAILY_TOTAL["DAILY_TOTAL"]
    V_RUNNING_TOTAL["RUNNING_TOTAL"]
  end

  ORD_ORDER_DATE --> V_ORDER_DATE
  ORD_ORDER_TOTAL --> V_DAILY_TOTAL
  ORD_ORDER_TOTAL --> V_RUNNING_TOTAL
```
