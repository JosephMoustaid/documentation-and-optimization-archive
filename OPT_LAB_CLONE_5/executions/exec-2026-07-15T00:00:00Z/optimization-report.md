# Optimization Report

## Object

- **URN:** OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY
- **Type:** VIEW

## Previous Definition

```sql
create or replace view V_CUSTOMER_ORDER_SUMMARY(
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	EMAIL,
	COUNTRY,
	SIGNUP_DATE,
	IS_ACTIVE,
	LIFETIME_VALUE,
	NUM_ORDERS,
	TOTAL_SPENT,
	LAST_ORDER
) as
SELECT
    c.*,
    (SELECT COUNT(*)      FROM orders o WHERE o.customer_id = c.customer_id) AS num_orders,
    (SELECT SUM(order_total) FROM orders o WHERE o.customer_id = c.customer_id) AS total_spent,
    (SELECT MAX(order_date)  FROM orders o WHERE o.customer_id = c.customer_id) AS last_order
FROM customers c;
```

## Optimized Attempt (Executed SQL)

```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
    c.*,
    COUNT(o.order_id) AS num_orders,
    SUM(o.order_total) AS total_spent,
    MAX(o.order_date) AS last_order
FROM retail.customers c
LEFT JOIN retail.orders o
    ON o.customer_id = c.customer_id
GROUP BY
    c.*
```

## Result

- **Status:** FAILED
- **Error:** MCP Server tool error: SQL compilation error:
syntax error line 11 at position 6 unexpected '*'.
request-id: 6b475f56-4be0-4742-9a5b-0bd14d231ead
- **Message:** Execution failed for optimized definition; original view definition remains in place.
