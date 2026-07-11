# Column lineage — OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY

This is a best-effort column lineage based on the view definition.

## Direct pass-through columns (from `OPT_LAB_CLONE_3.RETAIL.CUSTOMERS`)

The view selects `c.*`, therefore all customer columns are passed through unchanged.

- `CUSTOMER_ID`  ⟵ `CUSTOMERS.CUSTOMER_ID`
- `FIRST_NAME`   ⟵ `CUSTOMERS.FIRST_NAME`
- `LAST_NAME`    ⟵ `CUSTOMERS.LAST_NAME`
- `EMAIL`        ⟵ `CUSTOMERS.EMAIL`
- `COUNTRY`      ⟵ `CUSTOMERS.COUNTRY`
- `SIGNUP_DATE`  ⟵ `CUSTOMERS.SIGNUP_DATE`
- `IS_ACTIVE`    ⟵ `CUSTOMERS.IS_ACTIVE`
- `LIFETIME_VALUE` ⟵ `CUSTOMERS.LIFETIME_VALUE`

## Derived columns (from aggregated `OPT_LAB_CLONE_3.RETAIL.ORDERS`)

- `NUM_ORDERS`  ⟵ `COALESCE(o.num_orders, 0)` where `o.num_orders = COUNT(*)` grouped by `ORDERS.CUSTOMER_ID`
- `TOTAL_SPENT` ⟵ `COALESCE(o.total_spent, 0)` where `o.total_spent = SUM(ORDERS.ORDER_TOTAL)` grouped by `ORDERS.CUSTOMER_ID`
- `LAST_ORDER`  ⟵ `o.last_order` where `o.last_order = MAX(ORDERS.ORDER_DATE)` grouped by `ORDERS.CUSTOMER_ID`

## Join keys

- `CUSTOMERS.CUSTOMER_ID` = `ORDERS.CUSTOMER_ID`

