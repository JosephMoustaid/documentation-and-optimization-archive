# Schema: OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK (VIEW)

## Object

- Database: OPT_LAB_CLONE_4
- Schema: RETAIL
- View: V_LOW_STOCK

## Columns (Deterministic Order)

| Ordinal | Column Name     | Source Expression      | Source Table Alias |
|--------:|------------------|------------------------|-------------------|
| 1       | INVENTORY_ID     | i.inventory_id         | i                 |
| 2       | WAREHOUSE_CODE   | i.warehouse_code       | i                 |
| 3       | PRODUCT_ID       | i.product_id           | i                 |
| 4       | QTY_ON_HAND      | i.qty_on_hand          | i                 |
| 5       | REORDER_LEVEL    | i.reorder_level        | i                 |
| 6       | PRODUCT_NAME     | p.product_name         | p                 |
| 7       | SUPPLIER_NAME    | s.supplier_name        | s                 |

## Base Relations

1. OPT_LAB_CLONE_4.RETAIL.INVENTORY (alias: i)
2. OPT_LAB_CLONE_4.RETAIL.PRODUCTS (alias: p)
3. OPT_LAB_CLONE_4.RETAIL.SUPPLIERS (alias: s)

## Filter

- i.qty_on_hand < i.reorder_level

## Join Logic

- i LEFT JOIN p ON p.product_id = i.product_id
- i LEFT JOIN s ON s.supplier_id = i.supplier_id

## Definition (Executed)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK AS
/*
  Optimizations:
  - Replace scalar subqueries with explicit JOINs to avoid repeated lookups per row.
  - Qualify table references with schema to aid optimization and clarity.
*/
SELECT
    i.inventory_id,
    i.warehouse_code,
    i.product_id,
    i.qty_on_hand,
    i.reorder_level,
    p.product_name,
    s.supplier_name
FROM OPT_LAB_CLONE_4.RETAIL.inventory AS i
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.products  AS p
    ON p.product_id   = i.product_id
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.suppliers AS s
    ON s.supplier_id  = i.supplier_id
WHERE i.qty_on_hand < i.reorder_level;
```
