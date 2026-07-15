# Column Lineage

**Target:** `OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE` (VIEW)  
**Execution ID:** `exec-2026-07-12T12:45:00Z`

```mermaid
graph LR
  subgraph TARGET["OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE"]
    T1["SUPPLIER_ID"]
    T2["SUPPLIER_NAME"]
    T3["COUNTRY"]
    T4["SKU_COUNT"]
    T5["AVG_STOCK"]
  end

  subgraph S["OPT_LAB_CLONE_5.RETAIL.SUPPLIERS (s)"]
    S1["supplier_id"]
    S2["supplier_name"]
    S3["country"]
  end

  subgraph I["OPT_LAB_CLONE_5.RETAIL.INVENTORY (i)"]
    I1["inventory_id"]
    I2["qty_on_hand"]
    I3["supplier_id"]
  end

  S1 --> T1
  S2 --> T2
  S3 --> T3
  I1 --> T4
  I2 --> T5
  I3 -. join key .- S1
```

## Mapping Table

| Target column | Source expression |
|---|---|
| `SUPPLIER_ID` | `s.supplier_id` |
| `SUPPLIER_NAME` | `s.supplier_name` |
| `COUNTRY` | `s.country` |
| `SKU_COUNT` | `COUNT(i.inventory_id)` |
| `AVG_STOCK` | `AVG(i.qty_on_hand)` |
