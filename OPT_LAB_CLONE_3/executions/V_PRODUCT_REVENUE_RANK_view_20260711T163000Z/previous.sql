create or replace view V_PRODUCT_REVENUE_RANK(
	PRODUCT_ID,
	TOTAL_REVENUE,
	REVENUE_RANK
) as
SELECT
  oi.product_id,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM OPT_LAB_CLONE_3.RETAIL.order_items AS oi
GROUP BY oi.product_id;
