# Column lineage (best-effort)

Object: `RETAIL.SP_RECALC_ORDER_TOTALS` (PROCEDURE)

Because validation failed in DRY_RUN prior to database-context resolution, lineage is inferred from the SQL text.

## Target

- `orders.order_total`
  - Recomputed as `COALESCE((SELECT SUM(order_items.quantity * order_items.unit_price) ...), 0)` grouped per `orders.order_id` via correlated predicate `order_items.order_id = orders.order_id`.

## Inputs

- `orders.order_id` — used to correlate to `order_items.order_id`
- `order_items.order_id` — correlation key
- `order_items.quantity` — multiplied by `unit_price`
- `order_items.unit_price` — multiplied by `quantity`
