# Optimization Report — SP_APPLY_PRICE_INCREASE

## Goal
Increase performance of price update routine.

## Previous implementation (issue)
- Used a cursor to fetch `product_id` row-by-row and executed one `UPDATE` per product.
- This introduces significant overhead (looping, per-row DML) and scales poorly.

## Optimized implementation
- Replaced the loop with a single set-based `UPDATE` filtered by `category`.
- Uses `SQLROWCOUNT` to return the number of affected rows.

## Correctness considerations
- **Semantics**: Both versions update `unit_price` for products in the requested category; set-based update matches the logical intent.
- **Rounding**: Preserved rounding to 2 decimals.
- **Privileges / execution context**: Original used `EXECUTE AS OWNER`; optimized definition does not include it. If required in your environment, add `EXECUTE AS OWNER` to preserve behavior.

## DRY_RUN notes
Validated via EXPLAIN only; no database changes were applied.
