# Column Lineage: OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK (VIEW)

## Mapping (Deterministic Order)

| Target Column   | Source Column / Expression                         | Source Relation |
|----------------|-----------------------------------------------------|----------------|
| INVENTORY_ID   | i.inventory_id                                      | OPT_LAB_CLONE_4.RETAIL.INVENTORY |
| WAREHOUSE_CODE | i.warehouse_code                                    | OPT_LAB_CLONE_4.RETAIL.INVENTORY |
| PRODUCT_ID     | i.product_id                                        | OPT_LAB_CLONE_4.RETAIL.INVENTORY |
| QTY_ON_HAND    | i.qty_on_hand                                       | OPT_LAB_CLONE_4.RETAIL.INVENTORY |
| REORDER_LEVEL  | i.reorder_level                                     | OPT_LAB_CLONE_4.RETAIL.INVENTORY |
| PRODUCT_NAME   | p.product_name                                      | OPT_LAB_CLONE_4.RETAIL.PRODUCTS |
| SUPPLIER_NAME  | s.supplier_name                                     | OPT_LAB_CLONE_4.RETAIL.SUPPLIERS |

## Mermaid (Column-Level Lineage)

```mermaid
graph LR
  subgraph TARGET["OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK"]
    t1["INVENTORY_ID"]
    t2["WAREHOUSE_CODE"]
    t3["PRODUCT_ID"]
    t4["QTY_ON_HAND"]
    t5["REORDER_LEVEL"]
    t6["PRODUCT_NAME"]
    t7["SUPPLIER_NAME"]
  end

  subgraph INV["OPT_LAB_CLONE_4.RETAIL.INVENTORY"]
    i1["inventory_id"]
    i2["warehouse_code"]
    i3["product_id"]
    i4["qty_on_hand"]
    i5["reorder_level"]
    i6["supplier_id"]
  end

  subgraph PROD["OPT_LAB_CLONE_4.RETAIL.PRODUCTS"]
    p1["product_id"]
    p2["product_name"]
  end

  subgraph SUPP["OPT_LAB_CLONE_4.RETAIL.SUPPLIERS"]
    s1["supplier_id"]
    s2["supplier_name"]
  end

  i1 --> t1
  i2 --> t2
  i3 --> t3
  i4 --> t4
  i5 --> t5
  p2 --> t6
  s2 --> t7

  i3 -. join key .- p1
  i6 -. join key .- s1
```
