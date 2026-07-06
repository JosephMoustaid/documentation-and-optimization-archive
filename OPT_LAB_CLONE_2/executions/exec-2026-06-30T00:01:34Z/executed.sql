CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_CUSTOMER_LTV_RANKED AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table reference to avoid dependence on session database/schema.
  - Retained scalar correlated subquery to preserve exact ranking semantics,
    including any handling of ties and NULLs.
*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    (
        SELECT COUNT(*)
        FROM OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c2
        WHERE c2.lifetime_value > c.lifetime_value
    ) + 1 AS ltv_rank
FROM OPT_LAB_CLONE_2.RETAIL.CUSTOMERS AS c;