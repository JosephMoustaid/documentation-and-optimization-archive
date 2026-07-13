# Optimization report

Execution: `exec-2026-07-11T23:30:00Z`

- Object: `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS`
- Type: view
- Task: `opt-1`
- Mode: APPLY
- Status: **FAILED**

## What changed (attempted)

### Previous definition

- Used `p.*` selecting all columns from `OPT_LAB_CLONE_4.RETAIL.PRODUCTS`
- Declared output columns: `PRODUCT_ID, PRODUCT_NAME, CATEGORY, UNIT_PRICE, ACTIVE_FLAG`

### Attempted optimized definition

- Replaced `p.*` with an explicit column list:
  - `p.product_id`
  - `p.product_name`
  - `p.category_id`
  - `p.price`
  - `p.status`

## Failure details

**Error**

- `SQL compilation error: error line 5 at position 4 invalid identifier 'P.CATEGORY_ID'`

**Interpretation**

- The column `CATEGORY_ID` does not exist on `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (and likely `PRICE`, `STATUS` may also be invalid).

## Recommended remediation

1. Inspect the actual `PRODUCTS` table schema:

   ```sql
   DESC TABLE OPT_LAB_CLONE_4.RETAIL.PRODUCTS;
   ```

2. Align the optimized SELECT list to valid columns. Based on the previous view signature, expected columns include:

   - `PRODUCT_ID`
   - `PRODUCT_NAME`
   - `CATEGORY`
   - `UNIT_PRICE`
   - `ACTIVE_FLAG`

3. Re-run optimization in APPLY mode.

## Notes

- The filtering logic (`NOT EXISTS` on `ORDER_ITEMS` by `product_id`) appears semantically consistent between previous and attempted SQL.
