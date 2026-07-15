# Schema — OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK

## Object
- **URN**: `OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK`
- **Type**: `VIEW`

## Current definition (applied)
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_LOW_STOCK AS
/*
  Optimized view: low stock inventory

  Optimizations:
  1) Replaced scalar subqueries with explicit JOINs to PRODUCTS and SUPPLIERS
     to avoid per-row subquery execution and enable better join planning.
  2) Fully qualified PRODUCTS, SUPPLIERS, and INVENTORY tables to avoid
     search-path dependence and ensure stable name resolution.
*/
SELECT
    i.inventory_id,
    i.warehouse_code,
    i.product_id,
    i.qty_on_hand,
    i.reorder_level,
    p.product_name,
    s.supplier_name
FROM OPT_LAB_CLONE_5.RETAIL.INVENTORY AS i
LEFT JOIN OPT_LAB_CLONE_5.RETAIL.PRODUCTS AS p
    ON p.product_id = i.product_id
LEFT JOIN OPT_LAB_CLONE_5.RETAIL.SUPPLIERS AS s
    ON s.supplier_id = i.supplier_id
WHERE i.qty_on_hand < i.reorder_level
```

## Output columns
| # | Column | Source | Notes |
|---:|---|---|---|
| 1 | `inventory_id` | `INVENTORY.inventory_id` |  |
| 2 | `warehouse_code` | `INVENTORY.warehouse_code` |  |
| 3 | `product_id` | `INVENTORY.product_id` |  |
| 4 | `qty_on_hand` | `INVENTORY.qty_on_hand` |  |
| 5 | `reorder_level` | `INVENTORY.reorder_level` |  |
| 6 | `product_name` | `PRODUCTS.product_name` | via `LEFT JOIN` on `product_id` |
| 7 | `supplier_name` | `SUPPLIERS.supplier_name` | via `LEFT JOIN` on `supplier_id` |

## Filter
- `i.qty_on_hand < i.reorder_level`
