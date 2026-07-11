# Optimization report — OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS

## Objective

Improve maintainability and query stability by removing `SELECT c.*` and selecting explicit columns.

## Proposed change (DRY_RUN)

- Replace `c.*` with explicit customer fields.
- Qualify table references with fully-qualified names.

## Outcome

**FAILED validation**.

- Error: `SQL compilation error: error line 12 at position 4 invalid identifier 'C.PHONE'`
- Root cause: the optimized SQL selected `c.phone`, but `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` does not have a `PHONE` column in this environment.

## Recommendations

1. **Remove `c.phone`** from the select list (and from the view column list if explicitly declared), then re-run.
2. Alternatively, **add/restore a `PHONE` column** to `CUSTOMERS` if it is expected to exist.
3. If customer contact information is optional, consider a safer pattern:
   - select only known-stable columns, and add contact fields in a separate view/versioned contract.

## Additional notes

- The previous definition declared the view column list explicitly, but still used `c.*` in the select; this can create ambiguity and break when `CUSTOMERS` schema changes.
