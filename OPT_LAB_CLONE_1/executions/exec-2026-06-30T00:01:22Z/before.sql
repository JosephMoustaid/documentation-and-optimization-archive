CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_REVENUE_RANK AS
SELECT
 product_id,
 total_revenue,
 RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM (
 SELECT oi.product_id,
 SUM(oi.quantity * oi.unit_price) AS total_revenue
 FROM order_items oi
 GROUP BY oi.product_id
);