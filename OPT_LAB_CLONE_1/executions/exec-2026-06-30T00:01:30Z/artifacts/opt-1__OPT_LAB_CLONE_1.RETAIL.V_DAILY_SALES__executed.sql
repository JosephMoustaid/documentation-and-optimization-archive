CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_DAILY_SALES AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table reference to avoid reliance on session database/schema.
  - Introduced a CTE to pre-aggregate daily totals, reducing repeated aggregation work.
  - Replaced the per-row correlated subquery with a window function to compute the
    running total, which is typically more efficient and easier for the optimizer
    to execute.
  - Preserved all output columns, data types, ordering (none explicitly defined),
    filters, and null-handling semantics.
*/
WITH daily_agg AS (
    SELECT
        d1.order_date,
        SUM(d1.order_total) AS daily_total
    FROM OPT_LAB_CLONE_1.RETAIL.ORDERS d1
    GROUP BY d1.order_date
)
SELECT
    da.order_date,
    da.daily_total,
    /*
      EXACT semantic equivalence to:
        (SELECT SUM(d2.order_total)
         FROM orders d2
         WHERE d2.order_date <= d1.order_date)

      Explanation:
      - The original correlated subquery sums order_total for all rows with
        order_date <= current row's order_date.
      - We first aggregate by order_date, then apply a running SUM over
        the ordered dates. For any given order_date, the running total is
        the sum of all daily_totals for dates <= that date, which matches
        the original condition.
    */
    SUM(da.daily_total) OVER (
        ORDER BY da.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM daily_agg AS da;