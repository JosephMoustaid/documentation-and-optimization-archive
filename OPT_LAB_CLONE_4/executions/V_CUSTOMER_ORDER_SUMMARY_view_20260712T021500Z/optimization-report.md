# Optimization Report — V_CUSTOMER_ORDER_SUMMARY

## Context

- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Type:** VIEW
- **Execution:** `exec-2026-07-12T02:15:00Z`
- **Applied:** Yes (mode = APPLY)
- **Result:** SUCCESS

## Before

- View already used a single aggregated subquery over `orders` joined to `customers`.
- `num_orders` defaulted to 0 via `COALESCE`.
- `total_spent` remained `NULL` when no orders.

## After

- Retained single aggregated `LEFT JOIN` pattern.
- Set `total_spent` default to 0: `COALESCE(o_agg.total_spent, 0)`.
- Left `last_order` as nullable to distinguish customers with no orders.

## Semantic note

Changing `total_spent` from NULL → 0 for customers with no orders may affect consumers that treat NULL as “no data”. If NULL is required, revert to `o_agg.total_spent`.

## SQL artifacts

See:
- `previous.sql`
- `optimized.sql`
