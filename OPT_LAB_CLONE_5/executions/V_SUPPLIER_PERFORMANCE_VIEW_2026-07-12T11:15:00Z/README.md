# Execution README — exec-2026-07-12T11:15:00Z

## Summary

- **Database**: `OPT_LAB_CLONE_5`
- **Warehouse**: `ADF_WH`
- **Execution mode**: `APPLY`
- **Status**: `SUCCESS`
- **Timestamp**: `2026-07-12T11:15:00Z`

## Object

- **Object URN**: `OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE`
- **Object type**: `VIEW`

## What changed

**Before (previous definition)**

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

**After (applied / optimized)**

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimized supplier performance view

  Optimizations:
  1) Removed DISTINCT combined with window functions to avoid redundant sorting and de-duplication.
     - Replaced with an aggregated query grouped by supplier_id (and other projected supplier attrs).
  2) Aggregated metrics using standard GROUP BY instead of window functions, which is more efficient
     and semantically clearer for per-supplier metrics.
  3) Fully qualified table references with database and schema for stability.
  4) Preserved LEFT JOIN semantics so suppliers without inventory still appear with NULL metrics.
*/
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    COUNT(i.inventory_id) AS sku_count,
    AVG(i.qty_on_hand)   AS avg_stock
FROM OPT_LAB_CLONE_5.RETAIL.suppliers AS s
LEFT JOIN OPT_LAB_CLONE_5.RETAIL.inventory AS i
    ON i.supplier_id = s.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country;
```

## Artifacts in this folder

- `schema.md`
- `lineage.md`
- `column-lineage.md`
- `procedure-flow.md`
