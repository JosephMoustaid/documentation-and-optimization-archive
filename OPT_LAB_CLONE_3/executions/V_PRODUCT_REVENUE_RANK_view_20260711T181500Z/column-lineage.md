# Column lineage — V_PRODUCT_REVENUE_RANK

Best-effort mapping from the provided SQL.

| Output column | Derivation |
|---|---|
| `PRODUCT_ID` | `ORDER_ITEMS.product_id` |
| `TOTAL_REVENUE` | `SUM(ORDER_ITEMS.quantity * ORDER_ITEMS.unit_price)` |
| `REVENUE_RANK` | `RANK() OVER (ORDER BY TOTAL_REVENUE DESC)` |
