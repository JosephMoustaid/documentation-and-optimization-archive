CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_CUSTOMER_LTV_RANKED AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table reference to avoid dependence on database/schema search path.
  - Replaced correlated scalar subquery with an equivalent window function
    using COUNT(*) FILTER (WHERE ...) OVER (), which is semantically identical
    but typically more performant and easier for the optimizer to handle.
  - Preserved exact ranking semantics (1 + number of customers with strictly
    greater lifetime_value) and null-handling behavior.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    /*
      Original logic:
        (SELECT COUNT(*)
         FROM customers c2
         WHERE c2.lifetime_value > c.lifetime_value) + 1

      Equivalent window form:
        1 + COUNT(*) FILTER (WHERE c2.lifetime_value > c.lifetime_value) OVER () AS ltv_rank
      where the OVER () frame covers all rows, matching the uncorrelated scope of
      the original subquery while using the correlated condition.
    */
    1 + COUNT(*) FILTER (WHERE c2.lifetime_value > c.lifetime_value) OVER () AS ltv_rank
FROM OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c
/*
  Self-join solely to expose c2.lifetime_value for the FILTER condition.
  This preserves the original "compare against all customers" semantics.
*/
CROSS JOIN OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c2;
