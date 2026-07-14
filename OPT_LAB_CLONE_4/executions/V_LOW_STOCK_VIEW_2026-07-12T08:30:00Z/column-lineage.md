# Column lineage

Target: `OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK`

| Target column | Source relation | Source column / expression | Transformation |
|---|---|---|---|
| `INVENTORY_ID` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY i` | `i.inventory_id` | direct |
| `WAREHOUSE_CODE` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY i` | `i.warehouse_code` | direct |
| `PRODUCT_ID` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY i` | `i.product_id` | direct |
| `QTY_ON_HAND` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY i` | `i.qty_on_hand` | direct |
| `REORDER_LEVEL` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY i` | `i.reorder_level` | direct |
| `PRODUCT_NAME` | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS p` | `p.product_name` | joined via `p.product_id = i.product_id` |
| `SUPPLIER_NAME` | `OPT_LAB_CLONE_4.RETAIL.SUPPLIERS s` | `s.supplier_name` | joined via `s.supplier_id = i.supplier_id` |

```mermaid
flowchart TB
  subgraph INVENTORY[i: OPT_LAB_CLONE_4.RETAIL.INVENTORY]
    i_inventory_id[inventory_id]
    i_warehouse_code[warehouse_code]
    i_product_id[product_id]
    i_qty_on_hand[qty_on_hand]
    i_reorder_level[reorder_level]
    i_supplier_id[supplier_id]
  end

  subgraph PRODUCTS[p: OPT_LAB_CLONE_4.RETAIL.PRODUCTS]
    p_product_id[product_id]
    p_product_name[product_name]
  end

  subgraph SUPPLIERS[s: OPT_LAB_CLONE_4.RETAIL.SUPPLIERS]
    s_supplier_id[supplier_id]
    s_supplier_name[supplier_name]
  end

  subgraph VIEW[v: OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK]
    v_inventory_id[INVENTORY_ID]
    v_warehouse_code[WAREHOUSE_CODE]
    v_product_id[PRODUCT_ID]
    v_qty_on_hand[QTY_ON_HAND]
    v_reorder_level[REORDER_LEVEL]
    v_product_name[PRODUCT_NAME]
    v_supplier_name[SUPPLIER_NAME]
  end

  i_inventory_id --> v_inventory_id
  i_warehouse_code --> v_warehouse_code
  i_product_id --> v_product_id
  i_qty_on_hand --> v_qty_on_hand
  i_reorder_level --> v_reorder_level

  p_product_name --> v_product_name
  s_supplier_name --> v_supplier_name

  i_product_id -. join .-> p_product_id
  i_supplier_id -. join .-> s_supplier_id
```
