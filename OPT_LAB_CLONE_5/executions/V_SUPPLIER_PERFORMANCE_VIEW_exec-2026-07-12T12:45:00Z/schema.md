# Schema Documentation

**Object:** `OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE`  
**Object Type:** VIEW  
**Execution ID:** `exec-2026-07-12T12:45:00Z`  
**Execution Mode:** APPLY  
**Warehouse:** `ADF_WH`

## DDL (Applied)

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

## Output Columns

| Column | Expression | Notes |
|---|---|---|
| `SUPPLIER_ID` | `s.supplier_id` | Supplier identifier |
| `SUPPLIER_NAME` | `s.supplier_name` | Supplier name |
| `COUNTRY` | `s.country` | Supplier country |
| `SKU_COUNT` | `COUNT(i.inventory_id)` | Inventory row count per supplier; `0` when no inventory rows due to `LEFT JOIN` |
| `AVG_STOCK` | `AVG(i.qty_on_hand)` | Average on-hand quantity per supplier; `NULL` when no inventory rows |

## Source Objects

- `OPT_LAB_CLONE_5.RETAIL.SUPPLIERS` (alias `s`)
- `OPT_LAB_CLONE_5.RETAIL.INVENTORY` (alias `i`)
