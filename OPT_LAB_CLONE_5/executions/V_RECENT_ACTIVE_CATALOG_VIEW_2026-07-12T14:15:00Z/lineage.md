# Lineage — OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG

## Dataset lineage

```mermaid
flowchart LR
  P[(OPT_LAB_CLONE_5.RETAIL.PRODUCTS)] -->|join on PRODUCT_ID| V["OPT_LAB_CLONE_5.RETAIL.V_RECENT_ACTIVE_CATALOG\n(VIEW)"]
  I[(OPT_LAB_CLONE_5.RETAIL.INVENTORY)] -->|join on PRODUCT_ID| V

  V --> O[(Result set)]
```

## Notes

- This view returns active products in the `ELECTRONICS` category with inventory rows whose `LAST_RESTOCKED` falls within the current calendar year.
