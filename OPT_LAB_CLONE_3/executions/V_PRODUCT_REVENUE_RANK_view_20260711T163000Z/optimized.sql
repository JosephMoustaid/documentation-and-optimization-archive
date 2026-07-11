CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_PRODUCT_REVENUE_RANK AS
/*
  Optimizations:
  - Removed the unnecessary subquery; perform aggregation and ranking in a single query.
  - Fully qualified the base table (OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS) for stable name resolution.
  - Project only required columns: product_id, total_revenue, revenue_rank.
*/
SELECT
    oi.product_id,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS revenue_rank
FROM OPT_LAB_CLONE_3.RETAIL.ORDER_ITEMS AS oi
GROUP BY
    oi.product_id;
