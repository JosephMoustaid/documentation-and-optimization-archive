# Execution Documentation: OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG (VIEW)

- **Execution ID:** exec-2026-07-12T12:30:00Z
- **Database:** OPT_LAB_CLONE_5
- **Warehouse:** ADF_WH
- **Execution Mode:** APPLY
- **Status:** SUCCESS
- **Total Objects:** 1 (Successful: 1, Failed: 0)
- **Timestamp:** 2026-07-12T12:30:00Z

## Object

- **URN:** OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG
- **Type:** VIEW
- **Task ID:** opt-1
- **Result:** SUCCESS

## Summary of Changes

1. Fully qualified table references:
   - `OPT_LAB_CLONE_5.RETAIL.PRODUCTS`
   - `OPT_LAB_CLONE_5.RETAIL.INVENTORY`
2. Replaced `UPPER(p.category) = 'ELECTRONICS'` with a case-insensitive comparison:
   - `p.category COLLATE "en-ci" = 'ELECTRONICS'`
3. Replaced `YEAR(i.last_restocked) = YEAR(CURRENT_DATE)` with a SARGable half-open date range:
   - `i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)`
   - `i.last_restocked <  DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)`

## Artifacts

- [schema.md](./schema.md)
- [lineage.md](./lineage.md)
- [column-lineage.md](./column-lineage.md)
- [procedure-flow.md](./procedure-flow.md)
