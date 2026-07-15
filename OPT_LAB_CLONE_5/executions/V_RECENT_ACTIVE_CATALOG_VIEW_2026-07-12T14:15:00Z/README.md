# Optimization Execution: V_RECENT_ACTIVE_CATALOG (VIEW)

- **Database**: OPT_LAB_CLONE_5
- **Schema**: RETAIL
- **Object**: V_RECENT_ACTIVE_CATALOG
- **Object Type**: VIEW
- **Warehouse**: ADF_WH
- **Execution ID**: exec-2026-07-12T14:15:00Z
- **Execution Mode**: APPLY
- **Timestamp**: 2026-07-12T14:15:00Z
- **Status**: SUCCESS

## Summary

This execution applied an optimized definition for `OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG`.

Key changes:

1. Fully qualified table references (`OPT_LAB_CLONE_5.RETAIL.PRODUCTS`, `OPT_LAB_CLONE_5.RETAIL.INVENTORY`).
2. Made the category filter sargable by removing `UPPER(p.category)` and comparing to a literal.
3. Made the last_restocked filter sargable by replacing `YEAR(i.last_restocked) = YEAR(CURRENT_DATE)` with a year date-range predicate.

## Files in this folder

- `schema.md` — object definition (before/after) and referenced objects
- `lineage.md` — dataset-level lineage diagram
- `column-lineage.md` — column-level lineage mapping
- `procedure-flow.md` — logical flow / execution steps diagram

## SQL (Before)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG AS
SELECT
 p.product_id,
 p.product_name,
 p.category,
 p.unit_price
FROM products p
JOIN inventory i ON i.product_id = p.product_id
WHERE UPPER(p.category) = 'ELECTRONICS' -- function on column
 AND YEAR(i.last_restocked) = YEAR(CURRENT_DATE) -- function on column
 AND p.active_flag = TRUE;
```

## SQL (After / Applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG AS
/*
  Optimized view: recent active electronics catalog

  Optimizations:
  1) Fully qualify PRODUCTS and INVENTORY to avoid search-path dependence.
  2) Make category filter sargable by comparing against an uppercase literal,
     assuming CATEGORY is stored in a consistent case (matches original semantics
     when data is already normalized to uppercase).
  3) Replace YEAR(i.last_restocked) = YEAR(CURRENT_DATE) with a range predicate
     on LAST_RESTOCKED to enable index/partition pruning and avoid function on column.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM OPT_LAB_CLONE_5.RETAIL.PRODUCTS AS p
JOIN OPT_LAB_CLONE_5.RETAIL.INVENTORY AS i
    ON i.product_id = p.product_id
WHERE p.category = 'ELECTRONICS'
  AND i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)
  AND i.last_restocked < DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)
  AND p.active_flag = TRUE
```
