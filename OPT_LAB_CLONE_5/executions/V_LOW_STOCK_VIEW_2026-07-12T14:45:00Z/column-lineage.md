# Column Lineage — OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK

## Mapping
| Output column | Source expression | Upstream column(s) |
|---|---|---|
| `inventory_id` | `i.inventory_id` | `OPT_LAB_CLONE_5.RETAIL.INVENTORY.inventory_id` |
| `warehouse_code` | `i.warehouse_code` | `OPT_LAB_CLONE_5.RETAIL.INVENTORY.warehouse_code` |
| `product_id` | `i.product_id` | `OPT_LAB_CLONE_5.RETAIL.INVENTORY.product_id` |
| `qty_on_hand` | `i.qty_on_hand` | `OPT_LAB_CLONE_5.RETAIL.INVENTORY.qty_on_hand` |
| `reorder_level` | `i.reorder_level` | `OPT_LAB_CLONE_5.RETAIL.INVENTORY.reorder_level` |
| `product_name` | `p.product_name` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.product_name` |
| `supplier_name` | `s.supplier_name` | `OPT_LAB_CLONE_5.RETAIL.SUPPLIERS.supplier_name` |

## Join keys (non-output)
- `p.product_id = i.product_id`
- `s.supplier_id = i.supplier_id`

## Column lineage diagram
```mermaid
flowchart TB
  subgraph INV[OPT_LAB_CLONE_5.RETAIL.INVENTORY]
    inv_inventory_id[inventory_id]
    inv_warehouse_code[warehouse_code]
    inv_product_id[product_id]
    inv_qty_on_hand[qty_on_hand]
    inv_reorder_level[reorder_level]
    inv_supplier_id[supplier_id]
  end

  subgraph PROD[OPT_LAB_CLONE_5.RETAIL.PRODUCTS]
    prod_product_id[product_id]
    prod_product_name[product_name]
  end

  subgraph SUP[OPT_LAB_CLONE_5.RETAIL.SUPPLIERS]
    sup_supplier_id[supplier_id]
    sup_supplier_name[supplier_name]
  end

  subgraph V[OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK]
    v_inventory_id[inventory_id]
    v_warehouse_code[warehouse_code]
    v_product_id[product_id]
    v_qty_on_hand[qty_on_hand]
    v_reorder_level[reorder_level]
    v_product_name[product_name]
    v_supplier_name[supplier_name]
  end

  inv_inventory_id --> v_inventory_id
  inv_warehouse_code --> v_warehouse_code
  inv_product_id --> v_product_id
  inv_qty_on_hand --> v_qty_on_hand
  inv_reorder_level --> v_reorder_level

  prod_product_name --> v_product_name
  sup_supplier_name --> v_supplier_name

  inv_product_id -. join .-> prod_product_id
  inv_supplier_id -. join .-> sup_supplier_id
```
