# Schema — OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS (VIEW)

**Database:** `OPT_LAB_CLONE_5`  
**Schema:** `RETAIL`  
**Object:** `V_NEVER_ORDERED_PRODUCTS`  
**Type:** `VIEW`  
**Execution:** `exec-2026-07-12T12:15:00Z`  

## View definition (applied)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimized "never ordered products" view

  Optimizations:
  1) Fully qualified RETAIL.PRODUCTS and RETAIL.ORDER_ITEMS with database and schema
     to avoid search-path ambiguity and improve optimization.
  2) Replaced the NOT IN (subquery) predicate with a NULL-safe NOT EXISTS anti-join
     to avoid issues when ORDER_ITEMS.PRODUCT_ID can be NULL and to enable
     a more efficient anti-join execution plan.
  3) Kept SELECT p.* so the view’s output schema matches RETAIL.PRODUCTS exactly,
     preserving the original schema and semantics while improving performance.
*/
SELECT
    p.*
FROM OPT_LAB_CLONE_5.RETAIL.PRODUCTS AS p
WHERE NOT EXISTS (
    SELECT
        1
    FROM OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS AS oi
    WHERE oi.PRODUCT_ID = p.PRODUCT_ID
)
```

## Output columns

This view returns **all columns from** `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` (`p.*`).

> Column names/types are inherited from `RETAIL.PRODUCTS` at query time.
