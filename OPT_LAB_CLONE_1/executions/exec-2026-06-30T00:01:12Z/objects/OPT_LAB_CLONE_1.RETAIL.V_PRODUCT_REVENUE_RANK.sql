CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_REVENUE_RANK AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified the base table (OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS) for
    stable name resolution and to avoid accidental schema changes.
  - Simplified the query by removing the unnecessary subquery wrapper;
    the window function can operate directly on the aggregated result
    without changing semantics.
  - Preserved all behavior: same columns, data types, ordering, and
    null-handling as the original definition.
*/
SELECT
    oi.product_id,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS AS oi
GROUP BY
    oi.product_id;
