# Optimization Report — OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY

- **Execution:** exec-2026-07-12T02:15:00Z
- **Timestamp:** 2026-07-12T02:15:00Z
- **Warehouse:** ADF_WH
- **Status:** SUCCESS

## Applied change
- Updated the view definition to ensure `TOTAL_SPENT` returns **0** (via `COALESCE`) when a customer has no orders.

## Behavioral impact
- **Before:** `TOTAL_SPENT` was `NULL` for customers with zero orders.
- **After:** `TOTAL_SPENT` is `0` for customers with zero orders.
- `NUM_ORDERS` already defaulted to `0`.
- `LAST_ORDER` remains `NULL` when no orders exist.

## Performance notes
- The view uses a single aggregated pass over `orders` grouped by `customer_id` joined to `customers`.

## Applied SQL
See `optimized.sql`.
