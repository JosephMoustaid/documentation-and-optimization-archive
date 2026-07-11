CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
    c.*,
    COALESCE(o.num_orders, 0)      AS num_orders,
    COALESCE(o.total_spent, 0)     AS total_spent,
    o.last_order                   AS last_order
FROM OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c
LEFT JOIN (
    SELECT
        o.CUSTOMER_ID,
        COUNT(*)                  AS num_orders,
        SUM(o.ORDER_TOTAL)        AS total_spent,
        MAX(o.ORDER_DATE)         AS last_order
    FROM OPT_LAB_CLONE_3.RETAIL.ORDERS o
    GROUP BY o.CUSTOMER_ID
) o
    ON o.CUSTOMER_ID = c.CUSTOMER_ID;
