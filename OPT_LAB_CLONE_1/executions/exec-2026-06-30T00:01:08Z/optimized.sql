CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_CUSTOMER_LTV_RANKED AS
/*
  Optimizations (behavior-preserving):
  - Explicitly qualified base table references with schema for clarity.
  - Retained the original scalar subquery-based ranking logic to preserve
    exact behavior, including handling of ties and NULLs.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    /*
      Rank is defined as: 1 + number of customers with strictly higher
      lifetime_value than the current customer.
      This preserves the original semantics exactly.
    */
    (
        SELECT COUNT(*)
        FROM OPT_LAB_CLONE_1.RETAIL.customers AS c2
        WHERE c2.lifetime_value > c.lifetime_value
    ) + 1 AS ltv_rank
FROM OPT_LAB_CLONE_1.RETAIL.customers AS c;
