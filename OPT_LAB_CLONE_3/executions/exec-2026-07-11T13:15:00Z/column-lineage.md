# Column lineage — OPT_LAB_CLONE_3.RETAIL.V_PRODUCT_REVENUE_RANK

Source: `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS` (`oi`)

| Target column | Derivation | Source columns |
|---|---|---|
| `PRODUCT_ID` | `oi.product_id` | `ORDER_ITEMS.PRODUCT_ID` |
| `TOTAL_REVENUE` | `SUM(oi.quantity * oi.unit_price)::NUMBER(38, 2)` | `ORDER_ITEMS.QUANTITY`, `ORDER_ITEMS.UNIT_PRICE` |
| `REVENUE_RANK` | `RANK() OVER (ORDER BY total_revenue DESC, product_id)` | `TOTAL_REVENUE` (derived), `PRODUCT_ID` |
