# Column lineage — OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS

> Status: FAILED (DRY_RUN validation)
> Error: invalid identifier `C.PHONE`

## Selected columns (optimized proposal)

| Output column | Source expression | Source object |
|---|---|---|
| ORDER_ID | `o.order_id` | `OPT_LAB_CLONE_3.RETAIL.ORDERS o` |
| ORDER_DATE | `o.order_date` | `OPT_LAB_CLONE_3.RETAIL.ORDERS o` |
| ORDER_STATUS | `o.status` | `OPT_LAB_CLONE_3.RETAIL.ORDERS o` |
| CUSTOMER_ID | `c.customer_id` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c` |
| FIRST_NAME | `c.first_name` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c` |
| LAST_NAME | `c.last_name` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c` |
| EMAIL | `c.email` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c` |
| PHONE | `c.phone` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c` (INVALID COLUMN) |
| CUSTOMER_STATUS | `c.status` | `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c` |
| ORDER_ITEM_ID | `oi.order_item_id` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS oi` |
| PRODUCT_ID | `oi.product_id` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS oi` |
| QUANTITY | `oi.quantity` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS oi` |
| UNIT_PRICE | `oi.unit_price` | `OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS oi` |
| PRODUCT_NAME | `p.product_name` | `OPT_LAB_CLONE_3.RETAIL.PRODUCTS p` |
| CATEGORY | `p.category` | `OPT_LAB_CLONE_3.RETAIL.PRODUCTS p` |
| PAYMENT_AMOUNT | `pay.amount` | `OPT_LAB_CLONE_3.RETAIL.PAYMENTS pay` |
| PAYMENT_METHOD | `pay.method` | `OPT_LAB_CLONE_3.RETAIL.PAYMENTS pay` |
| PAYMENT_STATUS | `pay.status` | `OPT_LAB_CLONE_3.RETAIL.PAYMENTS pay` |

## Notes

- The original view used `c.*`, which is fragile and may unintentionally add/remove columns with schema changes.
- The optimization replaced `c.*` with an explicit column list. Validation failed because `c.phone` is not present in the underlying `CUSTOMERS` table.
