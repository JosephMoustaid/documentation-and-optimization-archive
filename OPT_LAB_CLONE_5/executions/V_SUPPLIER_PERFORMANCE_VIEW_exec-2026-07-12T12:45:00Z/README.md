# Execution Summary

**Execution ID:** `exec-2026-07-12T12:45:00Z`  
**Database:** `OPT_LAB_CLONE_5`  
**Warehouse:** `ADF_WH`  
**Mode:** APPLY  
**Status:** SUCCESS

## Target Object

- **URN:** `OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE`
- **Type:** VIEW
- **Task ID:** opt-1

## Result

Optimized VIEW applied successfully. `OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE` now uses grouped aggregates over fully qualified `SUPPLIERS` and `INVENTORY` tables while preserving `LEFT JOIN` semantics.

## Before (Previous Definition)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE AS
SELECT DISTINCT
 s.supplier_id,
 s.supplier_name,
 s.country,
 COUNT(i.inventory_id) OVER (PARTITION BY s.supplier_id) AS sku_count,
 AVG(i.qty_on_hand) OVER (PARTITION BY s.supplier_id) AS avg_stock
FROM suppliers s
LEFT JOIN inventory i ON i.supplier_id = s.supplier_id;
```

## After (Applied Definition)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimized "supplier performance" view

  Optimizations:
  1) Fully qualified base tables (OPT_LAB_CLONE_5.RETAIL.SUPPLIERS and
     OPT_LAB_CLONE_5.RETAIL.INVENTORY) to avoid search-path ambiguity.
  2) Replaced DISTINCT + window functions with grouped aggregates, which
     removes redundant deduplication while preserving the result set:
       - COUNT(i.inventory_id) OVER (PARTITION BY s.supplier_id)
         → COUNT(i.inventory_id)
       - AVG(i.qty_on_hand) OVER (PARTITION BY s.supplier_id)
         → AVG(i.qty_on_hand)
     grouped by supplier_id, supplier_name, country.
  3) Preserved LEFT JOIN semantics so suppliers without inventory still
     appear with sku_count = 0 and avg_stock = NULL.
*/
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    COUNT(i.inventory_id) AS sku_count,
    AVG(i.qty_on_hand)    AS avg_stock
FROM OPT_LAB_CLONE_5.RETAIL.SUPPLIERS AS s
LEFT JOIN OPT_LAB_CLONE_5.RETAIL.INVENTORY AS i
    ON i.supplier_id = s.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country
```

## Artifacts

- [schema.md](./schema.md)
- [lineage.md](./lineage.md)
- [column-lineage.md](./column-lineage.md)
- [procedure-flow.md](./procedure-flow.md)
