# Column Lineage — OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY

## Source tables
- `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS` (aliased `c`)
- `OPT_LAB_CLONE_3.RETAIL.ORDERS` (aliased `o`, aggregated as `o_agg`)

## Output columns
### Customer columns
- `c.*` — all columns from `CUSTOMERS` are projected as-is.

### Derived metrics from ORDERS
- `NUM_ORDERS`  
  - Source: `COUNT(*)` over `ORDERS` grouped by `CUSTOMER_ID`
- `TOTAL_SPENT`  
  - Source: `SUM(o.order_total)` over `ORDERS` grouped by `CUSTOMER_ID`
- `LAST_ORDER`  
  - Source: `MAX(o.order_date)` over `ORDERS` grouped by `CUSTOMER_ID`

## Join semantics
- `LEFT JOIN` on `CUSTOMER_ID` preserves customers with no orders (metrics may be NULL depending on downstream handling).
