# Schema — OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS

## Object
- Database: `OPT_LAB_CLONE_4`
- Schema: `RETAIL`
- Name: `V_NEVER_ORDERED_PRODUCTS`
- Type: `VIEW`

## Definition (applied)
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimized view: V_NEVER_ORDERED_PRODUCTS
  Optimizations / Fixes:
  - Fixed invalid projection (previously `SELECT p.`) to select all product columns via `p.*`.
  - Fully qualified table references (already present) retained for clarity and stability.
  - Used NOT EXISTS correlated subquery to efficiently find products with no order_items.
*/
SELECT
    p.*
FROM OPT_LAB_CLONE_4.RETAIL.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_4.RETAIL.order_items AS oi
    WHERE oi.product_id = p.product_id
);
```

## Upstream references
- `OPT_LAB_CLONE_4.RETAIL.products` (alias: `p`)
- `OPT_LAB_CLONE_4.RETAIL.order_items` (alias: `oi`)

## Output columns
- `p.*` (all columns from `OPT_LAB_CLONE_4.RETAIL.products`)

## Notes
- The prior definition contained an invalid projection (`SELECT p.`). This execution fixes the view to return all product columns.
