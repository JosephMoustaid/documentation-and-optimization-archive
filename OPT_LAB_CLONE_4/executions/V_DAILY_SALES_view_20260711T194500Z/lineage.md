# Lineage — `OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES`

## Upstream
- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (`d1`)

## Downstream
- Not analyzed (no usage graph provided).

## Notes
The optimized view computes daily aggregates from `ORDERS` and then derives a running total using a window function ordered by `ORDER_DATE`.
