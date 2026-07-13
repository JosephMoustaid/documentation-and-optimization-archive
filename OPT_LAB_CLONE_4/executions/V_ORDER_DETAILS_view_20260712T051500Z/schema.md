# Schema notes (best-effort)

This execution failed during compilation, so schema capture is limited to what is visible from the view definitions.

## Target object

- **View:** `OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS`

## Referenced base objects

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (alias `o`)
- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (alias `c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (alias `oi`)
- `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- `OPT_LAB_CLONE_4.RETAIL.PAYMENTS` (alias `pay`, left join)

## Known valid customer attributes (from previous definition)

The previous (working) definition uses these customer columns:

- `CUSTOMER_ID`
- `FIRST_NAME`
- `LAST_NAME`
- `EMAIL`
- `COUNTRY`
- `SIGNUP_DATE`
- `IS_ACTIVE`
- `LIFETIME_VALUE`

## Columns that caused failure

The executed SQL referenced columns that are not present in the previous definition and likely do not exist in `CUSTOMERS`:

- `C.PHONE`
- `C.CREATED_AT`
- `C.STATUS` (as `customer_status`)
