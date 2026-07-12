CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
SELECT
    c.*,
    COALESCE(o_agg.num_orders, 0)      AS num_orders,
    COALESCE(o_agg.total_spent, 0)     AS total_spent,
    o_agg.last_order                   AS last_order
FROM OPT_LAB_CLONE_3.RETAIL.CUSTOMERS c
LEFT JOIN (
    SELECT
        customer_id,
        COUNT(*)              AS num_orders,
        SUM(order_total)      AS total_spent,
        MAX(order_date)       AS last_order
    FROM OPT_LAB_CLONE_3.RETAIL.ORDERS
    GROUP BY customer_id
) o_agg
    ON o_agg.customer_id = c.customer_id;
