# Column Lineage — OPT_LAB_CLONE_5.RETAIL.V_NEVER_ORDERED_PRODUCTS

**Execution:** `exec-2026-07-12T12:15:00Z`

## Summary

The view projects `p.*`, so:

- Every output column in `V_NEVER_ORDERED_PRODUCTS` maps **1:1** to the same-named column in `OPT_LAB_CLONE_5.RETAIL.PRODUCTS`.
- The `ORDER_ITEMS` table is used **only for filtering** (anti-join) via `oi.PRODUCT_ID = p.PRODUCT_ID`.

## Key predicate lineage

- `NOT EXISTS (...)` anti-join filter:
  - `OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS.PRODUCT_ID` ↔ `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.PRODUCT_ID`

## Mermaid (column/predicate lineage)

```mermaid
graph LR
  subgraph PRODUCTS[OPT_LAB_CLONE_5.RETAIL.PRODUCTS]
    P_PROD_ID[PRODUCT_ID]
    P_ALL[ALL OTHER COLUMNS (p.*)]
  end

  subgraph ORDER_ITEMS[OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS]
    OI_PROD_ID[PRODUCT_ID]
  end

  P_ALL --> V_ALL[V_NEVER_ORDERED_PRODUCTS (all columns)]
  P_PROD_ID --> V_ALL
  OI_PROD_ID -. filters via NOT EXISTS .-> V_ALL
  OI_PROD_ID --> P_PROD_ID
```
