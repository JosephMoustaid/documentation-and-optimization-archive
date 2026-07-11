# Column Lineage — OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE

## Table interactions

### OPT_LAB_CLONE_3.RETAIL.PRODUCTS

- **Filter column(s):**
  - `category` filtered by input parameter `CAT`
- **Updated column(s):**
  - `unit_price` updated to `ROUND(unit_price * (1 + PCT/100), 2)` using input parameter `PCT`

## Notes

- The procedure performs a set-based `UPDATE`; no SELECT projection/derivation beyond `ROW_COUNT` retrieval.
