# Lineage — SP_APPLY_PRICE_INCREASE (procedure)

Procedures do not expose a stable column-level output schema.

## Data flow (high level)
- Reads: `OPT_LAB_CLONE_3.RETAIL.PRODUCTS` (filter: `category = :CAT`)
- Writes: `OPT_LAB_CLONE_3.RETAIL.PRODUCTS` (`unit_price` update)
