CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_REVENUE_RANK AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified ORDER_ITEMS table to avoid dependency on current schema.
  - Introduced a CTE (product_revenue) for clarity; logic and results remain identical.
  - Kept RANK() window function and ordering semantics exactly the same.
*/
WITH product_revenue AS (
    SELECT
        oi.product_id,
        /*
          SUM over (quantity * unit_price) is preserved exactly.
          No change to arithmetic or aggregation level.
        */
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS AS oi
    GROUP BY oi.product_id
)
SELECT
    pr.product_id,
    pr.total_revenue,
    RANK() OVER (ORDER BY pr.total_revenue DESC) AS revenue_rank
FROM product_revenue AS pr;