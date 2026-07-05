# Optimization Execution Summary

- **Database:** OPT_LAB_CLONE_1
- **Execution ID:** exec-2026-06-30T00:01:29Z
- **Timestamp:** 2026-06-30T00:01:29Z
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Overall status:** SUCCESS

## Results

| Task | Object | Type | Status | Time (ms) |
|---:|---|---|---|---:|
| opt-1 | OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS | VIEW | SUCCESS | 150 |

## Change applied

**Before:** correlated subquery counting returned orders per customer.

**After:** `LEFT JOIN` to `OPT_LAB_CLONE_1.RETAIL.ORDERS` filtered to `status = 'RETURNED'` plus `GROUP BY` aggregation to compute `returned_orders`.

### Notes on equivalence
- Uses `COUNT(o.order_id)`; if `order_id` can be NULL, prefer `COUNT(*)` to exactly match the original `COUNT(*)` semantics.
