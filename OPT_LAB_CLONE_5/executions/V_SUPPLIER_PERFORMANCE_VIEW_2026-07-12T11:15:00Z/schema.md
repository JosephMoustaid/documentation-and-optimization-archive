# Schema — OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE (VIEW)

- **Database**: `OPT_LAB_CLONE_5`
- **Schema**: `RETAIL`
- **Object**: `V_SUPPLIER_PERFORMANCE`
- **Type**: `VIEW`
- **Warehouse**: `ADF_WH`
- **Execution mode**: `APPLY`
- **Execution id**: `exec-2026-07-12T11:15:00Z`
- **Timestamp**: `2026-07-12T11:15:00Z`

## View definition (applied)

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

## Output columns

| Ordinal | Column | Type | Source | Notes |
|---:|---|---|---|---|
| 1 | `supplier_id` | (inherited) | `OPT_LAB_CLONE_5.RETAIL.suppliers.supplier_id` | Group-by key |
| 2 | `supplier_name` | (inherited) | `OPT_LAB_CLONE_5.RETAIL.suppliers.supplier_name` | Group-by key |
| 3 | `country` | (inherited) | `OPT_LAB_CLONE_5.RETAIL.suppliers.country` | Group-by key |
| 4 | `sku_count` | NUMBER | `COUNT(OPT_LAB_CLONE_5.RETAIL.inventory.inventory_id)` | COUNT ignores NULLs; LEFT JOIN keeps suppliers with 0 inventory as 0 (if COUNT over joined rows) |
| 5 | `avg_stock` | FLOAT/NUMBER | `AVG(OPT_LAB_CLONE_5.RETAIL.inventory.qty_on_hand)` | AVG ignores NULLs; suppliers with no inventory yield NULL |

## Inputs

- `OPT_LAB_CLONE_5.RETAIL.suppliers` (alias `s`)
- `OPT_LAB_CLONE_5.RETAIL.inventory` (alias `i`)

## Join and aggregation

- Join: `LEFT JOIN` on `i.supplier_id = s.supplier_id`
- Aggregation: `GROUP BY s.supplier_id, s.supplier_name, s.country`
