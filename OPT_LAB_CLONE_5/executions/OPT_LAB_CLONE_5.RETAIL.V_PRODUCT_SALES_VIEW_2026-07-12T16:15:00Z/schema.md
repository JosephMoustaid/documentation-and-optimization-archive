# Schema — OPT_LAB_CLONE_5.RETAIL.V_PRODUCT_SALES

**Object**: `OPT_LAB_CLONE_5.RETAIL.V_PRODUCT_SALES`  
**Type**: VIEW  
**Execution**: `exec-2026-07-12T16:15:00Z`  

## Output columns

| Ordinal | Column | Expression | Source table.column |
|---:|---|---|---|
| 1 | `PRODUCT_ID` | `p.PRODUCT_ID` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.PRODUCT_ID` |
| 2 | `PRODUCT_NAME` | `p.PRODUCT_NAME` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.PRODUCT_NAME` |
| 3 | `CATEGORY` | `p.CATEGORY` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.CATEGORY` |
| 4 | `ORDER_ID` | `o.ORDER_ID` | `OPT_LAB_CLONE_5.RETAIL.ORDERS.ORDER_ID` |
| 5 | `ORDER_DATE` | `o.ORDER_DATE` | `OPT_LAB_CLONE_5.RETAIL.ORDERS.ORDER_DATE` |
| 6 | `QUANTITY` | `oi.QUANTITY` | `OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS.QUANTITY` |
| 7 | `UNIT_PRICE` | `oi.UNIT_PRICE` | `OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS.UNIT_PRICE` |
| 8 | `LINE_TOTAL` | `oi.QUANTITY * oi.UNIT_PRICE` | Derived (`ORDER_ITEMS.QUANTITY`, `ORDER_ITEMS.UNIT_PRICE`) |

## Base relations

- `OPT_LAB_CLONE_5.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_5.RETAIL.ORDER_ITEMS` (alias `oi`)
- `OPT_LAB_CLONE_5.RETAIL.ORDERS` (alias `o`)
- `OPT_LAB_CLONE_5.RETAIL.CUSTOMERS` (alias `c`) — join-only (no projected columns)

## Join conditions

- `oi.PRODUCT_ID = p.PRODUCT_ID`
- `o.ORDER_ID = oi.ORDER_ID`
- `c.CUSTOMER_ID = o.CUSTOMER_ID`

## Notes

- Optimization removed `DISTINCT` from the SELECT list, eliminating a global deduplication step.
- All base tables are fully qualified to `OPT_LAB_CLONE_5.RETAIL.<TABLE>`.
