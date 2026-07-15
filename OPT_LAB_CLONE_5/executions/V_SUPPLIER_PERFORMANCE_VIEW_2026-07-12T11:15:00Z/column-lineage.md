# Column lineage — OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE

## Mapping

| View column | Expression | Upstream column(s) |
|---|---|---|
| `supplier_id` | `s.supplier_id` | `OPT_LAB_CLONE_5.RETAIL.suppliers.supplier_id` |
| `supplier_name` | `s.supplier_name` | `OPT_LAB_CLONE_5.RETAIL.suppliers.supplier_name` |
| `country` | `s.country` | `OPT_LAB_CLONE_5.RETAIL.suppliers.country` |
| `sku_count` | `COUNT(i.inventory_id)` | `OPT_LAB_CLONE_5.RETAIL.inventory.inventory_id` |
| `avg_stock` | `AVG(i.qty_on_hand)` | `OPT_LAB_CLONE_5.RETAIL.inventory.qty_on_hand` |

## Diagram

```mermaid
flowchart LR
  subgraph Suppliers[OPT_LAB_CLONE_5.RETAIL.suppliers]
    s_supplier_id[supplier_id]
    s_supplier_name[supplier_name]
    s_country[country]
  end

  subgraph Inventory[OPT_LAB_CLONE_5.RETAIL.inventory]
    i_inventory_id[inventory_id]
    i_supplier_id[supplier_id]
    i_qty_on_hand[qty_on_hand]
  end

  subgraph View[OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE]
    v_supplier_id[supplier_id]
    v_supplier_name[supplier_name]
    v_country[country]
    v_sku_count[sku_count]
    v_avg_stock[avg_stock]
  end

  s_supplier_id --> v_supplier_id
  s_supplier_name --> v_supplier_name
  s_country --> v_country

  i_inventory_id -->|COUNT| v_sku_count
  i_qty_on_hand -->|AVG| v_avg_stock

  i_supplier_id -. join key .- s_supplier_id
```
