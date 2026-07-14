# Schema — OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK (VIEW)

**Database:** `OPT_LAB_CLONE_4`  
**Schema:** `RETAIL`  
**Object:** `V_LOW_STOCK`  
**Type:** `VIEW`

## Columns

| Column | Type | Source | Notes |
|---|---|---|---|
| INVENTORY_ID | (inferred) | `inventory.inventory_id` | From inventory table |
| WAREHOUSE_CODE | (inferred) | `inventory.warehouse_code` | From inventory table |
| PRODUCT_ID | (inferred) | `inventory.product_id` | From inventory table |
| QTY_ON_HAND | (inferred) | `inventory.qty_on_hand` | Used for low-stock predicate |
| REORDER_LEVEL | (inferred) | `inventory.reorder_level` | Used for low-stock predicate |
| PRODUCT_NAME | (inferred) | `products.product_name` | Joined via `product_id` |
| SUPPLIER_NAME | (inferred) | `suppliers.supplier_name` | Joined via `supplier_id` |

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

## Previous definition (for reference)

```sql
create or replace view V_LOW_STOCK(
	INVENTORY_ID,
	WAREHOUSE_CODE,
	PRODUCT_ID,
	QTY_ON_HAND,
	REORDER_LEVEL,
	PRODUCT_NAME,
	SUPPLIER_NAME
) as
SELECT
 i.inventory_id,
 i.warehouse_code,
 i.product_id,
 i.qty_on_hand,
 i.reorder_level,
 (SELECT p.product_name FROM products p WHERE p.product_id = i.product_id) AS product_name,
 (SELECT s.supplier_name FROM suppliers s WHERE s.supplier_id = i.supplier_id) AS supplier_name
FROM inventory i
WHERE i.qty_on_hand < i.reorder_level;
```
