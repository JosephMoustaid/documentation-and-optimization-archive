# Column lineage — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

| View column | Upstream column(s) |
|---|---|
| INVENTORY_ID | `inventory.inventory_id` |
| WAREHOUSE_CODE | `inventory.warehouse_code` |
| PRODUCT_ID | `inventory.product_id` |
| QTY_ON_HAND | `inventory.qty_on_hand` |
| REORDER_LEVEL | `inventory.reorder_level` |
| PRODUCT_NAME | `products.product_name` (join via `inventory.product_id = products.product_id`) |
| SUPPLIER_NAME | `suppliers.supplier_name` (join via `inventory.supplier_id = suppliers.supplier_id`) |
