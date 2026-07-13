# Schema notes (inferred from provided SQL)

> This artifact is inferred from the provided `previous.sql` / `optimized.sql` only. No live database introspection was performed.

## Objects referenced

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias `o`)
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (alias `c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (alias `oi`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.PAYMENTS` (alias `pay`, LEFT JOIN)

## CUSTOMER columns known to be valid (from previous definition)

- `CUSTOMER_ID`
- `FIRST_NAME`
- `LAST_NAME`
- `EMAIL`
- `COUNTRY`
- `SIGNUP_DATE`
- `IS_ACTIVE`
- `LIFETIME_VALUE`

## Columns referenced in attempted optimized SQL that caused failure

- `PHONE`
- `ADDRESS`
- `CITY`
- `STATE`
- `POSTAL_CODE`

At least `PHONE` is not present, per error `invalid identifier 'C.PHONE'`.
