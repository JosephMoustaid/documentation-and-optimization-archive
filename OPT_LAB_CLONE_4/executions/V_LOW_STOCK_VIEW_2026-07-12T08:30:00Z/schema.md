# Schema

## Object
- **Database**: `OPT_LAB_CLONE_4`
- **Schema**: `RETAIL`
- **Name**: `V_LOW_STOCK`
- **Type**: `VIEW`

## Definition (applied)
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK AS
/*
  Optimized view: V_LOW_STOCK
  Optimizations:
  - Replaced scalar subqueries with explicit joins to PRODUCTS and SUPPLIERS
    to avoid per-row subquery evaluation and improve join planning.
  - Fully qualified table references for clarity and to avoid search path issues.
  - Selected only necessary columns and preserved existing filter predicate.
*/
SELECT
    i.inventory_id,
    i.warehouse_code,
    i.product_id,
    i.qty_on_hand,
    i.reorder_level,
    p.product_name,
    s.supplier_name
FROM OPT_LAB_CLONE_4.RETAIL.inventory  AS i
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.products  AS p
       ON p.product_id = i.product_id
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.suppliers AS s
       ON s.supplier_id = i.supplier_id
WHERE i.qty_on_hand < i.reorder_level;
```

## Output columns
| Ordinal | Column | Source expression |
|---:|---|---|
| 1 | `INVENTORY_ID` | `i.inventory_id` |
| 2 | `WAREHOUSE_CODE` | `i.warehouse_code` |
| 3 | `PRODUCT_ID` | `i.product_id` |
| 4 | `QTY_ON_HAND` | `i.qty_on_hand` |
| 5 | `REORDER_LEVEL` | `i.reorder_level` |
| 6 | `PRODUCT_NAME` | `p.product_name` |
| 7 | `SUPPLIER_NAME` | `s.supplier_name` |

## Referenced relations
- `OPT_LAB_CLONE_4.RETAIL.INVENTORY` (alias `i`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.SUPPLIERS` (alias `s`)

## Join + filter logic
- `i LEFT JOIN p ON p.product_id = i.product_id`
- `i LEFT JOIN s ON s.supplier_id = i.supplier_id`
- Filter: `i.qty_on_hand < i.reorder_level`
