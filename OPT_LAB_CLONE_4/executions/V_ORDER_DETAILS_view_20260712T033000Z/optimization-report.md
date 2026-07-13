# Optimization report — OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS

- **Execution:** exec-2026-07-12T03:30:00Z
- **Mode:** APPLY
- **Status:** FAILED

## Attempted changes

- Fully qualified table references (`OPT_LAB_CLONE_4.RETAIL.<table>`).
- Expanded customer projection from a limited set of known columns to a larger explicit list.

## Failure details

Error:

```
SQL compilation error: error line 20 at position 4 invalid identifier 'C.PHONE'
```

Root cause:

The attempted optimized SQL references customer columns that do not exist in `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS`.

Columns referenced in attempted optimized SQL but not present in the prior view definition:

- `PHONE`
- `ADDRESS`
- `CITY`
- `STATE`
- `POSTAL_CODE`

## Recommended remediation

1. Inspect the actual `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` table definition.
2. Remove or rename invalid column references from the optimized SQL.
3. Re-run APPLY.

If the intent is to include contact/address attributes, join to the correct table that contains them (or update the source table schema).
