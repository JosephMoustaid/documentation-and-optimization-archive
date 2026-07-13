# Optimization report

## Execution

- **Execution ID:** exec-2026-07-12T01:30:00Z
- **Mode:** APPLY
- **Status:** FAILED
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS` (view)

## Failure

**Error**

```
SQL compilation error: error line 6 at position 4 invalid identifier 'P.PRICE'
```

**Cause**

The executed optimized SQL referenced columns that do not exist in `OPT_LAB_CLONE_4.RETAIL.PRODUCTS`:

- `p.price`
- `p.active`

The previous definition indicates the expected columns are:

- `UNIT_PRICE`
- `ACTIVE_FLAG`

## Recommended fix

Update the view SELECT list to use valid column names (for example `p.unit_price AS unit_price` / `p.active_flag AS active_flag`) and rerun APPLY.

## Executed SQL (failed)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    p.active
FROM OPT_LAB_CLONE_4.RETAIL.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_4.RETAIL.order_items AS oi
    WHERE oi.product_id = p.product_id
);
```
