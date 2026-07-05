CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_DAILY_SALES AS
/*
  Optimizations (behavior-preserving):
  - Replaced correlated subquery with a window function over a pre-aggregated
    daily totals subquery to avoid repeated scans of ORDERS.
  - Fully qualified ORDERS table reference to avoid dependency on current schema.
  - Preserved exact behavior:
      * running_total is the sum of order_total for all rows with order_date
        <= current order_date (based on the original correlated subquery).
      * GROUP BY on order_date ensures one row per order_date as in original.
*/
WITH daily_totals AS (
    SELECT
        o.order_date,
        SUM(o.order_total) AS daily_total
    FROM OPT_LAB_CLONE_1.RETAIL.ORDERS AS o
    GROUP BY o.order_date
)
SELECT
    dt.order_date,
    dt.daily_total,
    /*
      Running total equivalent to the original correlated subquery:
      (SELECT SUM(d2.order_total)
         FROM orders d2
        WHERE d2.order_date <= d1.order_date)

      Since daily_totals already aggregates by order_date, summing daily_total
      over all dates <= current order_date yields the same result.
    */
    SUM(dt.daily_total) OVER (
        ORDER BY dt.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM daily_totals AS dt;