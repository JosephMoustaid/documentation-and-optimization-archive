# Procedure Flow — exec-2026-07-12T14:30:00Z

- **Warehouse**: `ADF_WH`
- **Database**: `OPT_LAB_CLONE_5`
- **Mode**: `APPLY`
- **Objects attempted**: 1
- **Succeeded**: 1
- **Failed**: 0

## Flow

```mermaid
flowchart TD
  A[Start execution\nexec-2026-07-12T14:30:00Z] --> B[Load current object definition\nOPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE]
  B --> C[Generate optimized SQL\n- fully qualify tables\n- replace DISTINCT + window aggregates with GROUP BY]
  C --> D[Apply change\nCREATE OR REPLACE VIEW]
  D --> E{Success?}
  E -->|Yes| F[Record SUCCESS\nopt-1]
  E -->|No| G[Record FAILURE\nopt-1]
  F --> H[End]
  G --> H[End]
```

## Task: opt-1

- **Object**: `OPT_LAB_CLONE_5.RETAIL.V_SUPPLIER_PERFORMANCE`
- **Type**: `VIEW`
- **Status**: `SUCCESS`

### Applied SQL

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
