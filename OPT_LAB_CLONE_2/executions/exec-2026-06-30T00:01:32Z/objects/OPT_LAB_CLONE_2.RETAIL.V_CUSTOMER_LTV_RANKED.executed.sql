CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_CUSTOMER_LTV_RANKED AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table reference to avoid dependence on session database/schema.
  - Replaced scalar correlated subquery with analytic ranking function (RANK) for
    equivalent logic and better performance.
    Original expression:
      (SELECT COUNT(*) FROM customers c2
       WHERE c2.lifetime_value > c.lifetime_value) + 1
    This computes the number of customers with strictly greater lifetime_value,
    which is exactly RANK() when ordered by lifetime_value DESC.
  - Preserves strict "greater than" semantics, ties behavior, result values,
    and output types.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    RANK() OVER (
        ORDER BY c.lifetime_value DESC
    ) AS ltv_rank
FROM OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c;
