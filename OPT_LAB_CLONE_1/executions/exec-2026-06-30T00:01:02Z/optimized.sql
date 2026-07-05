-- Optimized SQL for: OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_REVENUE_RANK
-- Status in this run: FAILED (not executed in this environment; no Snowflake result available)

CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_REVENUE_RANK AS
/*
  Optimization notes (behavior-preserving):
  - Removed unnecessary subquery by aggregating directly in the main SELECT.
  - Kept the same output schema and ranking logic.
*/
SELECT
    oi.product_id,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM order_items oi
GROUP BY oi.product_id;
