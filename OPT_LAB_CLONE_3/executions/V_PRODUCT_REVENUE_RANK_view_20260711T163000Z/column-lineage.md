# Column lineage — OPT_LAB_CLONE_3.RETAIL.V_PRODUCT_REVENUE_RANK

| Output column | Derived from | Transformation |
|---|---|---|
| `PRODUCT_ID` | `ORDER_ITEMS.PRODUCT_ID` | Direct pass-through |
| `TOTAL_REVENUE` | `ORDER_ITEMS.QUANTITY`, `ORDER_ITEMS.UNIT_PRICE` | `SUM(quantity * unit_price)` |
| `REVENUE_RANK` | `ORDER_ITEMS.QUANTITY`, `ORDER_ITEMS.UNIT_PRICE` | `RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC)` |
