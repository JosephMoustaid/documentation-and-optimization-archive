CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_CUSTOMER_LTV_RANKED AS
SELECT
 c.customer_id,
 c.first_name,
 c.last_name,
 c.lifetime_value,
 (SELECT COUNT()
 FROM customers c2
 WHERE c2.lifetime_value > c.lifetime_value) + 1 AS ltv_rank
FROM customers c;
