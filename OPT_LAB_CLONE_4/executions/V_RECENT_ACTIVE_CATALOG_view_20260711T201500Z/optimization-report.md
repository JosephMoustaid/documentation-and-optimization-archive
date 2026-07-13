# Optimization report

## Execution
- **Execution ID:** `exec-2026-07-11T20:15:00Z`
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG`
- **Type:** view
- **Mode:** APPLY
- **Status:** SUCCESS

## Findings in previous definition
1. **Non-SARGable category predicate**
   - Previous: `UPPER(p.category) = 'ELECTRONICS'`
   - Issue: applying a function to the column can prevent pruning and efficient search.

2. **Non-SARGable date predicate**
   - Previous: `YEAR(i.last_restocked) = YEAR(CURRENT_DATE)`
   - Issue: function on `last_restocked` blocks range pruning and can increase scan cost.

3. **Unqualified table references**
   - Previous referenced `products` and `inventory` without database/schema qualifiers.

## Applied changes
- Category filter rewritten to:
  - `p.category ILIKE 'electronics'`
- Date filter rewritten to a half-open range for the current calendar year:
  - `i.last_restocked >= DATE_FROM_PARTS(YEAR(CURRENT_DATE), 1, 1)`
  - `i.last_restocked <  DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 1, 1, 1)`
- Fully-qualified sources:
  - `OPT_LAB_CLONE_4.RETAIL.products`
  - `OPT_LAB_CLONE_4.RETAIL.inventory`
- Preserved business logic:
  - `p.active_flag = TRUE`

## Expected impact
- Improved predicate pushdown and partition/micro-partition pruning.
- Reduced CPU overhead from per-row function evaluation.

## Validation suggestions
- Compare query profile before/after (bytes scanned, partitions pruned).
- Confirm row counts match between prior and optimized definitions for the same date.
