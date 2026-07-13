# Schema (inferred) — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

Inferred from the view SQL text (no live DESCRIBE available in this execution context).

| Column | Source expression | Notes |
|---|---|---|
| INVENTORY_ID | `i.inventory_id` | from `OPT_LAB_CLONE_4.RETAIL.inventory` |
| WAREHOUSE_CODE | `i.warehouse_code` | from `inventory` |
| PRODUCT_ID | `i.product_id` | from `inventory` |
| QTY_ON_HAND | `i.qty_on_hand` | from `inventory` |
| REORDER_LEVEL | `i.reorder_level` | from `inventory` |
| PRODUCT_NAME | `p.product_name` | from `OPT_LAB_CLONE_4.RETAIL.products` (LEFT JOIN) |
| SUPPLIER_NAME | `s.supplier_name` | from `OPT_LAB_CLONE_4.RETAIL.suppliers` (LEFT JOIN) |
