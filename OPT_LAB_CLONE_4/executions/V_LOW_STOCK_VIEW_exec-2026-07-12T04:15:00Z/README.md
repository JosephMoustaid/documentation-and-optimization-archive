# Execution Documentation: OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK (VIEW)

- Execution ID: exec-2026-07-12T04:15:00Z
- Timestamp: 2026-07-12T04:15:00Z
- Warehouse: ADF_WH
- Execution Mode: APPLY
- Status: SUCCESS

## Object

- Database: OPT_LAB_CLONE_4
- Schema: RETAIL
- Name: V_LOW_STOCK
- Type: VIEW
- URN: OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK

## Summary

Optimized VIEW applied successfully. OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK now uses LEFT JOINs to PRODUCTS and SUPPLIERS with fully qualified references, eliminating scalar subqueries and preserving the low-stock filter.

## Key Changes (Deterministic Order)

1. Replaced two scalar subqueries with LEFT JOINs to PRODUCTS and SUPPLIERS
2. Fully qualified table references with OPT_LAB_CLONE_4.RETAIL
3. Preserved low-stock filter (qty_on_hand < reorder_level)

## Executed SQL

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

## Previous Definition

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

## Artifacts

- [schema.md](./schema.md)
- [lineage.md](./lineage.md)
- [column-lineage.md](./column-lineage.md)
- [procedure-flow.md](./procedure-flow.md)
