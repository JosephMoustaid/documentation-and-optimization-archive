# Execution Documentation: exec-2026-07-12T10:30:00Z (FAILED)

- **Database:** OPT_LAB_CLONE_5
- **Schema:** RETAIL
- **Object:** `OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS`
- **Object type:** VIEW
- **Warehouse:** ADF_WH
- **Execution mode:** APPLY
- **Status:** FAILED
- **Timestamp:** 2026-07-12T10:30:00Z

## Summary

This execution attempted to apply an optimized definition for the view `V_NEVER_ORDERED_PRODUCTS`, intended to return products that have never been ordered. The APPLY failed due to invalid column references in the optimized SQL.

## Failure record

- **Error:** `SQL compilation error: error line 15 at position 4 invalid identifier 'P.PRICE'`
- **Cause:** The optimized view definition references columns that do not exist in `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` (e.g., `P.PRICE` and potentially `P.CREATED_AT`).
- **Recommended fix:** Update the SELECT list to use valid columns from `PRODUCTS` (e.g., `UNIT_PRICE`, `ACTIVE_FLAG`, and `CREATED_AT` if present) and re-apply.

## Previous definition

```sql
create or replace view V_NEVER_ORDERED_PRODUCTS(
	PRODUCT_ID,
	PRODUCT_NAME,
	CATEGORY,
	UNIT_PRICE,
	ACTIVE_FLAG
) as
SELECT p.*
FROM products p
WHERE p.product_id NOT IN (SELECT oi.product_id FROM order_items oi);
```

## Attempted optimized SQL (failed)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimized view definition for products that have never been ordered
  Optimizations / fixes:
  - Fixed invalid projection (previously `SELECT p.`) to select explicit columns.
  - Replaced `NOT IN (subquery)` with an anti-join using `NOT EXISTS`,
    which is generally safer (no NULL-related surprises) and often more efficient.
  - Qualified tables with database and schema for clarity and to avoid context issues.
  - Limited projection to key business attributes; adjust as needed.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    p.created_at
FROM OPT_LAB_CLONE_5.RETAIL.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_5.RETAIL.order_items AS oi
    WHERE oi.product_id = p.product_id
);
```

## Artifacts

- `schema.md` — inferred schema expectations from the view definition(s)
- `lineage.md` — object-level lineage
- `column-lineage.md` — column-level lineage (includes failure notes)
- `procedure-flow.md` — execution flow (Mermaid)
