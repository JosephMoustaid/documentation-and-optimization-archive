# Summary — V_PRODUCT_REVENUE_RANK (view)

- **Database**: OPT_LAB_CLONE_4
- **Schema**: RETAIL
- **Object**: V_PRODUCT_REVENUE_RANK
- **Execution ID**: exec-2026-07-12T02:00:00Z
- **Timestamp**: 2026-07-12T02:00:00Z
- **Warehouse**: ADF_WH
- **Mode**: APPLY
- **Status**: SUCCESS

## What changed
The view was simplified from a nested subquery that aggregated revenue and then ranked, to a single SELECT that performs the aggregation and ranking in one step.

## Result
`OPT_LAB_CLONE_4.RETAIL.V_PRODUCT_REVENUE_RANK` now aggregates and ranks product revenue directly from `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` using fully-qualified references.