# Execution Summary — exec-2026-06-30T00:01:13Z

- **Database:** OPT_LAB_CLONE_1
- **Schema scope:** ALL
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** FAILED
- **Totals:** 0 total / 0 succeeded / 1 failed

## Failure
The optimized definition for `OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_SALES` was produced, but **was not executed in this run context**, so no Snowflake execution result is available.

## Primary object
- **Object:** `OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_SALES` (VIEW)
- **Task:** opt-1
- **Status:** FAILED
- **Error:** Execution not performed in this run context; no Snowflake execution result is available.

## Provided DDL (not executed)
See: `optimized.sql`

## Related prior failed run
- **Execution:** `exec-2026-06-30T00:01:11Z`
- **Object:** `OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE`
- **Status:** FAILED
- **Reason:** Execution not performed in this run context; no Snowflake execution result is available.
