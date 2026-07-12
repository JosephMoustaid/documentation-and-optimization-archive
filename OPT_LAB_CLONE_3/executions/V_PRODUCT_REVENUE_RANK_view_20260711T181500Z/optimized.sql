CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_PRODUCT_REVENUE_RANK AS
WITH product_revenue AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS oi
    GROUP BY oi.product_id
)
SELECT
    product_id,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_revenue;
