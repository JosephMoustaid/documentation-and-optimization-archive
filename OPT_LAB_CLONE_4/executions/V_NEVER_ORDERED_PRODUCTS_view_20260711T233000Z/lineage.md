# Lineage

Object: `OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS`

## Upstream sources

Derived from:

1. `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (`p`)
2. `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (`oi`) — used in `NOT EXISTS` filter

## Transformation logic (from SQL)

The view returns rows from `PRODUCTS` where there is **no** matching row in `ORDER_ITEMS` by `product_id`.

```sql
WHERE NOT EXISTS (
  SELECT 1
  FROM OPT_LAB_CLONE_4.RETAIL.order_items AS oi
  WHERE oi.product_id = p.product_id
)
```

## Notes

- The APPLY attempt failed due to invalid identifier(s) in the optimized SELECT list (e.g., `p.category_id`).
- The original definition selected `p.*` and declared a fixed output column list; therefore the precise mapping depends on the `PRODUCTS` schema at runtime.
