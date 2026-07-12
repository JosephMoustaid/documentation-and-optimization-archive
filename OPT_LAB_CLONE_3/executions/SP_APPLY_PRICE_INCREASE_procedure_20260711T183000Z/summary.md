# Summary — SP_APPLY_PRICE_INCREASE (procedure)

- **Database**: OPT_LAB_CLONE_3
- **Schema**: RETAIL
- **Object**: OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE
- **Execution**: exec-2026-07-11T18:30:00Z
- **Mode**: DRY_RUN
- **Status**: VALIDATED (no changes applied)

## What changed
Rewrote a row-by-row cursor loop into a single set-based `UPDATE` statement.

## Expected impact
- Reduced runtime by avoiding per-row updates and context switching.
- Simpler code path; leverages Snowflake set processing.
