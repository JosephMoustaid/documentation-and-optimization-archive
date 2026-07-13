# Schema (inferred from SQL text)

## View

- **Name:** `OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY`
- **Type:** view

## Referenced tables

- `OPT_LAB_CLONE_4.RETAIL.CUSTOMERS` (aliased `c`)
- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (aliased `o` / `o_agg`)

## Output columns

From the *previous* view definition (explicit column list):

- `CUSTOMER_ID`
- `NUM_ORDERS`
- `TOTAL_SPENT`
- `LAST_ORDER`

From the *optimized (attempted)* SQL (APPLY failed):

- `CUSTOMER_ID`
- `CUSTOMER_NAME` (referenced, but invalid in `CUSTOMERS` per compilation error)
- `EMAIL`
- `NUM_ORDERS`
- `TOTAL_SPENT`
- `LAST_ORDER`

> Note: Actual `CUSTOMERS` columns are not available in this payload; the error indicates `CUSTOMER_NAME` is not present.