# Procedure / query flow

Object: `OPT_LAB_CLONE_4.RETAIL.V_LOW_STOCK` (VIEW)

## Logical flow
1. Read rows from `OPT_LAB_CLONE_4.RETAIL.INVENTORY` (`i`).
2. `LEFT JOIN` `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (`p`) on `p.product_id = i.product_id`.
3. `LEFT JOIN` `OPT_LAB_CLONE_4.RETAIL.SUPPLIERS` (`s`) on `s.supplier_id = i.supplier_id`.
4. Filter rows where `i.qty_on_hand < i.reorder_level`.
5. Project output columns.

```mermaid
flowchart TD
  A[Scan INVENTORY i] --> B[LEFT JOIN PRODUCTS p
ON p.product_id = i.product_id]
  B --> C[LEFT JOIN SUPPLIERS s
ON s.supplier_id = i.supplier_id]
  C --> D{Filter:
qty_on_hand < reorder_level}
  D -->|pass| E[Project columns
inventory_id, warehouse_code, product_id,
qty_on_hand, reorder_level,
product_name, supplier_name]
  D -->|fail| F[Discard]
```

## Optimization summary
- Scalar subqueries for `product_name` and `supplier_name` were replaced with joins to avoid per-row subquery evaluation.
