# Schema — OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE

- **Database**: `OPT_LAB_CLONE_5`
- **Schema**: `RETAIL`
- **Object**: `V_SUPPLIER_PERFORMANCE`
- **Type**: `VIEW`
- **Execution**: `exec-2026-07-12T14:30:00Z`

## Current definition (applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE AS
/*
  Optimized view: supplier performance

  Optimizations:
  1) Fully qualify SUPPLIERS and INVENTORY tables to avoid search-path dependence.
  2) Replace DISTINCT + window aggregates with grouped aggregates to remove
     redundant row processing while preserving the output schema and semantics.
*/
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    COUNT(i.inventory_id) AS sku_count,
    AVG(i.qty_on_hand) AS avg_stock
FROM OPT_LAB_CLONE_5.RETAIL.SUPPLIERS AS s
LEFT JOIN OPT_LAB_CLONE_5.RETAIL.INVENTORY AS i
    ON i.supplier_id = s.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country
```

## Previous definition (before optimization)

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

## Output columns

| Column | Expression (applied) | Notes |
|---|---|---|
| `SUPPLIER_ID` | `s.supplier_id` | Grouping key |
| `SUPPLIER_NAME` | `s.supplier_name` | Grouping key |
| `COUNTRY` | `s.country` | Grouping key |
| `SKU_COUNT` | `COUNT(i.inventory_id)` | Count of inventory rows per supplier (LEFT JOIN retains suppliers with 0) |
| `AVG_STOCK` | `AVG(i.qty_on_hand)` | Average quantity on hand per supplier |
