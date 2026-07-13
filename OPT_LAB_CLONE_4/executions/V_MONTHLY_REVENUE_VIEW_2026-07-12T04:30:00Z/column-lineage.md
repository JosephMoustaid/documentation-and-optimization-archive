# Column Lineage — OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE

## Column-to-Source Mapping

| Target Column | Source Column(s) | Transformation |
|---|---|---|
| ORDER_MONTH | OPT_LAB_CLONE_4.RETAIL.ORDERS.ORDER_DATE | `DATE_TRUNC('month', order_date)` |
| ORDER_COUNT | OPT_LAB_CLONE_4.RETAIL.ORDERS.ORDER_ID | `COUNT(DISTINCT order_id)` |
| REVENUE | OPT_LAB_CLONE_4.RETAIL.ORDERS.ORDER_TOTAL | `SUM(order_total)` |

## Diagram

```mermaid
graph LR
  subgraph SRC[OPT_LAB_CLONE_4.RETAIL.ORDERS]
    ODATE[ORDER_DATE]
    OID[ORDER_ID]
    OTOTAL[ORDER_TOTAL]
    OSTATUS[STATUS]
  end

  subgraph TGT[OPT_LAB_CLONE_4.RETAIL.V_MONTHLY_REVENUE]
    T_MONTH[ORDER_MONTH]
    T_COUNT[ORDER_COUNT]
    T_REV[REVENUE]
  end

  ODATE -->|DATE_TRUNC('month', ...)| T_MONTH
  OID -->|COUNT DISTINCT| T_COUNT
  OTOTAL -->|SUM| T_REV
  OSTATUS -.->|filter status IN ('PAID','SHIPPED')| T_MONTH
```
