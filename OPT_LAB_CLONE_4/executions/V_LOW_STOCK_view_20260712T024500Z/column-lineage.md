# Column lineage — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

| Output column | Expression (optimized) | Source object.column |
|---|---|---|
| `INVENTORY_ID` | `i.inventory_id` | `INVENTORY.INVENTORY_ID` |
| `WAREHOUSE_CODE` | `i.warehouse_code` | `INVENTORY.WAREHOUSE_CODE` |
| `PRODUCT_ID` | `i.product_id` | `INVENTORY.PRODUCT_ID` |
| `QTY_ON_HAND` | `i.qty_on_hand` | `INVENTORY.QTY_ON_HAND` |
| `REORDER_LEVEL` | `i.reorder_level` | `INVENTORY.REORDER_LEVEL` |
| `PRODUCT_NAME` | `p.product_name` | `PRODUCTS.PRODUCT_NAME` |
| `SUPPLIER_NAME` | `s.supplier_name` | `SUPPLIERS.SUPPLIER_NAME` |

## Notes
- `PRODUCT_NAME` and `SUPPLIER_NAME` previously came from scalar subqueries; they now come from explicit joins.
- `LEFT JOIN` preserves rows from `inventory` even when a product/supplier lookup is missing.
