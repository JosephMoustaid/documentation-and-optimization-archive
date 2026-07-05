-- Optimized definition for: OPT_LAB_CLONE_1.RETAIL.V_DAILY_SALES
-- Note: This was NOT executed in the run context; apply manually in Snowflake.

CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_DAILY_SALES AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified base table reference (OPT_LAB_CLONE_1.RETAIL.ORDERS) to avoid
    resolution ambiguities and ensure consistent object binding.
  - Added explicit aliases for clarity and consistency.
  - Preserved the scalar subquery pattern and GROUP BY semantics exactly to
    maintain the original running_total behavior and row-level granularity.
*/
SELECT
    d1.order_date,
    SUM(d1.order_total) AS daily_total,
    (
        SELECT SUM(d2.order_total)
        FROM OPT_LAB_CLONE_1.RETAIL.ORDERS AS d2
        WHERE d2.order_date <= d1.order_date
    ) AS running_total
FROM OPT_LAB_CLONE_1.RETAIL.ORDERS AS d1
GROUP BY d1.order_date;
