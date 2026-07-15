# Column Lineage — OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG

## Column mappings
| Target column | Source expression | Base column(s) |
|---|---|---|
| `PRODUCT_ID` | `p.product_id` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.PRODUCT_ID` |
| `PRODUCT_NAME` | `p.product_name` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.PRODUCT_NAME` |
| `CATEGORY` | `p.category` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.CATEGORY` |
| `UNIT_PRICE` | `p.unit_price` | `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.UNIT_PRICE` |

## Filter lineage (non-output)
- `p.active_flag = TRUE` uses `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.ACTIVE_FLAG`
- Restock window uses `OPT_LAB_CLONE_5.RETAIL.INVENTORY.LAST_RESTOCKED`
- Category constraint uses `OPT_LAB_CLONE_5.RETAIL.PRODUCTS.CATEGORY`

## Diagram
```mermaid
flowchart TB
  subgraph PRODUCTS[OPT_LAB_CLONE_5.RETAIL.PRODUCTS]
    P1[PRODUCT_ID]
    P2[PRODUCT_NAME]
    P3[CATEGORY]
    P4[UNIT_PRICE]
    P5[ACTIVE_FLAG]
  end

  subgraph INVENTORY[OPT_LAB_CLONE_5.RETAIL.INVENTORY]
    I1[PRODUCT_ID]
    I2[LAST_RESTOCKED]
  end

  V1[VIEW.PRODUCT_ID]
  V2[VIEW.PRODUCT_NAME]
  V3[VIEW.CATEGORY]
  V4[VIEW.UNIT_PRICE]

  P1 --> V1
  P2 --> V2
  P3 --> V3
  P4 --> V4

  P5 -. filter .-> V1
  I2 -. filter .-> V1
  I1 -. join key .-> V1
  P1 -. join key .-> V1
```
