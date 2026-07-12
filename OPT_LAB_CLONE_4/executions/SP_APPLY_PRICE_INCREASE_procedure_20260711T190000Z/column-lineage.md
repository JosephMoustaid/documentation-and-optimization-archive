# Column Lineage (Procedure)

Column-level lineage is not computed for procedures in this pipeline.

## Observed (from optimized.sql)

- `products.unit_price` is updated based on its prior value and input parameter `pct`.
- `products.category` is used as a filter with input parameter `cat`.
