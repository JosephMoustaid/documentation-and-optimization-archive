# Column Lineage — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

## Column mapping

| View column | Expression | Upstream column(s) |
|---|---|---|
| INVENTORY_ID | `i.inventory_id` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY.inventory_id` |
| WAREHOUSE_CODE | `i.warehouse_code` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY.warehouse_code` |
| PRODUCT_ID | `i.product_id` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY.product_id` |
| QTY_ON_HAND | `i.qty_on_hand` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY.qty_on_hand` |
| REORDER_LEVEL | `i.reorder_level` | `OPT_LAB_CLONE_4.RETAIL.INVENTORY.reorder_level` |
| PRODUCT_NAME | `p.product_name` | `OPT_LAB_CLONE_4.RETAIL.PRODUCTS.product_name` |
| SUPPLIER_NAME | `s.supplier_name` | `OPT_LAB_CLONE_4.RETAIL.SUPPLIERS.supplier_name` |

## Mermaid (column-level lineage)

```mermaid
flowchart TB
  subgraph INV[OPT_LAB_CLONE_4.RETAIL.INVENTORY]
    inv_inventory_id[inventory_id]
    inv_warehouse_code[warehouse_code]
    inv_product_id[product_id]
    inv_qty_on_hand[qty_on_hand]
    inv_reorder_level[reorder_level]
    inv_supplier_id[supplier_id]
  end

  subgraph PROD[OPT_LAB_CLONE_4.RETAIL.PRODUCTS]
    prod_product_id[product_id]
    prod_product_name[product_name]
  end

  subgraph SUP[OPT_LAB_CLONE_4.RETAIL.SUPPLIERS]
    sup_supplier_id[supplier_id]
    sup_supplier_name[supplier_name]
  end

  subgraph V[OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK]
    v_inventory_id[INVENTORY_ID]
    v_warehouse_code[WAREHOUSE_CODE]
    v_product_id[PRODUCT_ID]
    v_qty_on_hand[QTY_ON_HAND]
    v_reorder_level[REORDER_LEVEL]
    v_product_name[PRODUCT_NAME]
    v_supplier_name[SUPPLIER_NAME]
  end

  inv_inventory_id --> v_inventory_id
  inv_warehouse_code --> v_warehouse_code
  inv_product_id --> v_product_id
  inv_qty_on_hand --> v_qty_on_hand
  inv_reorder_level --> v_reorder_level
  prod_product_name --> v_product_name
  sup_supplier_name --> v_supplier_name

  inv_product_id -. join .- prod_product_id
  inv_supplier_id -. join .- sup_supplier_id
```
