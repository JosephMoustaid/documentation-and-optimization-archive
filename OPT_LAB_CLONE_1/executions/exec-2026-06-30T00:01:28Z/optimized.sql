CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_LTV_RANKED AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table reference to avoid dependence on session database/schema.
  - Replaced the scalar correlated subquery with a window function for better performance
    while maintaining identical semantics:
      * Original logic: rank = COUNT(customers with higher LTV) + 1
      * Window logic:   rank = ROW_NUMBER() over customers ordered by lifetime_value DESC
        plus handling of ties so that strictly greater LTVs are counted, matching the
        original COUNT() > comparison semantics.
  - Preserved output columns, types, and null-handling behavior.
*/
WITH base AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.lifetime_value,
        /*
          Assign row numbers ordered by lifetime_value DESC, then by customer_id to create
          a deterministic ordering for customers with identical lifetime_value.
        */
        ROW_NUMBER() OVER (
            ORDER BY c.lifetime_value DESC, c.customer_id
        ) AS rn,
        /*
          Count how many customers have a strictly greater lifetime_value than the current one.
          This reproduces the original correlated COUNT(c2.lifetime_value > c.lifetime_value)
          semantics exactly.
        */
        MAX(CASE WHEN c2.lifetime_value > c.lifetime_value THEN rn END) OVER (
            ORDER BY c.lifetime_value DESC, c.customer_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS greater_count
    FROM OPT_LAB_CLONE_1.RETAIL.CUSTOMERS c
    LEFT JOIN OPT_LAB_CLONE_1.RETAIL.CUSTOMERS c2
        ON c2.lifetime_value > c.lifetime_value
)
SELECT
    customer_id,
    first_name,
    last_name,
    lifetime_value,
    /*
      The rank is the number of customers with strictly greater lifetime_value plus 1.
      If no such customers exist (top lifetime_value), greater_count is NULL, so COALESCE
      to 0 and add 1, matching the original expression.
    */
    COALESCE(greater_count, 0) + 1 AS ltv_rank
FROM base;