CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_CUSTOMER_LTV_RANKED AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    DENSE_RANK() OVER (ORDER BY c.lifetime_value DESC) AS ltv_rank
FROM OPT_LAB_CLONE_4.RETAIL.customers c;
