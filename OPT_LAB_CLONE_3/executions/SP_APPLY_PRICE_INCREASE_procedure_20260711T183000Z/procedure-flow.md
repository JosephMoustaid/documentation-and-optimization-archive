# Procedure Flow — SP_APPLY_PRICE_INCREASE

```mermaid
flowchart TD
    A([Start]) --> B[UPDATE PRODUCTS\nSET unit_price = ROUND(unit_price * (1 + PCT/100), 2)\nWHERE category = CAT]
    B --> C[rows_affected := SQLROWCOUNT]
    C --> D[RETURN 'Raised price on ' || rows_affected || ' products ...']
    D --> E([End])
```
