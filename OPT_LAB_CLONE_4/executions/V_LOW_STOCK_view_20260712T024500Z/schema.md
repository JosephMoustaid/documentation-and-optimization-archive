# Output schema — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

Inferred from the `SELECT` list in `optimized.sql`.

| Ordinal | Column | Source | Notes |
|---:|---|---|---|
| 1 | `INVENTORY_ID` | `inventory.inventory_id` | |
| 2 | `WAREHOUSE_CODE` | `inventory.warehouse_code` | |
| 3 | `PRODUCT_ID` | `inventory.product_id` | |
| 4 | `QTY_ON_HAND` | `inventory.qty_on_hand` | |
| 5 | `REORDER_LEVEL` | `inventory.reorder_level` | |
| 6 | `PRODUCT_NAME` | `products.product_name` | from `LEFT JOIN` |
| 7 | `SUPPLIER_NAME` | `suppliers.supplier_name` | from `LEFT JOIN` |

> Data types are not available in the execution payload; only column names/derivation are documented.
