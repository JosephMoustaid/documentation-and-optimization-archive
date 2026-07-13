CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    -- Add any other customer columns explicitly as needed instead of `c.*`
    COUNT(o.order_id)               AS num_orders,         -- Replaces correlated COUNT() subquery
    SUM(o.order_total)             AS total_spent,        -- Replaces correlated SUM(order_total) subquery
    MAX(o.order_date)              AS last_order          -- Replaces correlated MAX(order_date) subquery
FROM OPT_LAB_CLONE_4.RETAIL.customers AS c
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.orders    AS o
    ON o.customer_id = c.customer_id       -- Single join instead of three correlated subqueries
GROUP BY
    c.customer_id,
    c.customer_name,
    c.email;