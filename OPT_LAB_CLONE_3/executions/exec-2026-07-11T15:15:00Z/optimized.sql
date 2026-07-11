CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_DAILY_SALES AS
/*
    Optimizations / fixes:
    - Replaced correlated subquery with an analytic (window) function for running total.
      This avoids re-scanning ORDERS per row and lets Snowflake use a single pass
      with efficient window aggregation.
    - Fully qualified base table reference for stable name resolution.
*/
SELECT
    d.order_date,
    SUM(d.order_total) AS daily_total,
    SUM(SUM(d.order_total))
        OVER (ORDER BY d.order_date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM OPT_LAB_CLONE_3.RETAIL.orders AS d
GROUP BY
    d.order_date;
