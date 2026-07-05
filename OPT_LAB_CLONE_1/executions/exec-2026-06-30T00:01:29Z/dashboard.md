# Execution Dashboard (single-run)

- **Execution ID:** exec-2026-06-30T00:01:29Z
- **Database:** OPT_LAB_CLONE_1
- **Schema scope:** ALL
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Timestamp:** 2026-06-30T00:01:29Z
- **Status:** SUCCESS

## Objects

| Task | Object | Type | Status | Time (ms) |
|---:|---|---|---|---:|
| opt-1 | OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS | VIEW | SUCCESS | 150 |

## Key change

Optimized `OPT_LAB_CLONE_1.RETAIL.V_TOP_CUSTOMERS` by replacing a correlated subquery counting returned orders with a `LEFT JOIN` + `GROUP BY` aggregation for improved execution efficiency while preserving behavior.
