CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_CUSTOMER_ORDER_SUMMARY AS
/*
    Optimizations / fixes:
    - Replaced three correlated scalar subqueries with a single aggregated subquery
      over ORDERS grouped by CUSTOMER_ID to avoid repeated scans and per-row subquery
      evaluation.
    - Fully qualified base tables in OPT_LAB_CLONE_3.RETAIL for stable name resolution.
    - Replaced `c.*` with an explicit list of key customer columns to reduce scan size
      and avoid schema-change fragility.
    - Used LEFT JOIN so customers with zero orders are preserved; aggregated
      metrics will be NULL (or 0 when wrapped in COALESCE) in that case.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    c.signup_date,
    c.is_active,
    c.lifetime_value,

    COALESCE(o_agg.num_orders, 0)   AS num_orders,
    COALESCE(o_agg.total_spent, 0)  AS total_spent,
    o_agg.last_order                AS last_order
FROM OPT_LAB_CLONE_3.RETAIL.customers AS c
LEFT JOIN (
    SELECT
        o.customer_id,
        COUNT(*)           AS num_orders,
        SUM(o.order_total) AS total_spent,
        MAX(o.order_date)  AS last_order
    FROM OPT_LAB_CLONE_3.RETAIL.orders AS o
    GROUP BY o.customer_id
) AS o_agg
    ON o_agg.customer_id = c.customer_id;
