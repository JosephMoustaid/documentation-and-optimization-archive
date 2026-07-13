# Optimization report — V_NEVER_ORDERED_PRODUCTS

## Status
- **Result**: SUCCESS
- **Execution**: `exec-2026-07-12T03:15:00Z`

## Applied changes
1. **Projection cleanup**
   - Previous SQL contained an incomplete projection (`SELECT p.`).
   - Updated to `SELECT p.*` for a valid, maintainable definition.

2. **Fully-qualified object references**
   - Ensured upstream tables are fully qualified:
     - `OPT_LAB_CLONE_4.RETAIL.PRODUCTS`
     - `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS`

3. **Preserved anti-join semantics**
   - Retained `NOT EXISTS` to identify products with no related order items.

## Resulting definition
See `optimized.sql`.
