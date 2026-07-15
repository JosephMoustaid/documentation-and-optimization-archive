# Column Lineage: OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS

> This APPLY execution **FAILED**. Column lineage is derived from the attempted SQL and the previously-declared view signature.

## Output columns (previous signature)

| output_column | expected source | notes |
|--------------|------------------|-------|
| PRODUCT_ID   | `products.product_id` | previously declared |
| PRODUCT_NAME | `products.product_name` | previously declared |
| CATEGORY     | `products.category` | previously declared |
| UNIT_PRICE   | `products.unit_price` | previously declared |
| ACTIVE_FLAG  | `products.active_flag` | previously declared |

## Attempted optimized output columns (failed SQL)

| output_column | expression | base columns | status |
|--------------|------------|--------------|--------|
| PRODUCT_ID   | `p.product_id`   | `products.product_id` | ok |
| PRODUCT_NAME | `p.product_name` | `products.product_name` | ok |
| CATEGORY     | `p.category`     | `products.category` | ok |
| PRICE        | `p.price`        | `products.price` | **FAILED** (`price` column not found) |
| CREATED_AT   | `p.created_at`   | `products.created_at` | unknown (not validated) |

## Filter predicate lineage

- Anti-join condition:
  - `NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id)`
  - Uses:
    - `order_items.product_id`
    - `products.product_id`

## Failure note

- **Error:** `SQL compilation error: error line 15 at position 4 invalid identifier 'P.PRICE'`
- **Implication:** The view could not be created/replaced; downstream objects depending on this view were not updated.
