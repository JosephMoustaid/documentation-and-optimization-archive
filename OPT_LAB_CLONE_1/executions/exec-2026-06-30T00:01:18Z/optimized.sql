CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_LTV_RANKED AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified base table reference to avoid dependency on current database/schema.
  - Replaced the correlated scalar subquery with a window function (COUNT over window) for better performance
    while preserving identical results and null-handling behavior.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    /*
      Original logic:
      (SELECT COUNT(*) FROM customers c2 WHERE c2.lifetime_value > c.lifetime_value) + 1
      This counts how many customers have strictly greater lifetime_value, then adds 1.
      The equivalent using window functions is:
      COUNT(*) OVER (WHERE lifetime_value > c.lifetime_value) + 1.
    */
    COUNT(*) OVER (
        ORDER BY c.lifetime_value
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
    - COUNT(*) OVER (
        ORDER BY c.lifetime_value
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )
    + 1 AS ltv_rank
FROM OPT_LAB_CLONE_1.RETAIL.CUSTOMERS AS c;
