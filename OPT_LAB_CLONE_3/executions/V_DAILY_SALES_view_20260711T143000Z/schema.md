```mermaid
erDiagram
  OPT_LAB_CLONE_3__RETAIL__ORDERS {
    date order_date
    number order_total
  }

  OPT_LAB_CLONE_3__RETAIL__V_DAILY_SALES {
    date order_date
    number daily_total
    number running_total
  }

  OPT_LAB_CLONE_3__RETAIL__ORDERS ||--o{ OPT_LAB_CLONE_3__RETAIL__V_DAILY_SALES : derives
```
