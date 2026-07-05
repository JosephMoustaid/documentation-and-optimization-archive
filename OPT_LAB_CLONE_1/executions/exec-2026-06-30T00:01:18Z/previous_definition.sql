create or replace view VW_CUSTOMER_LTV_RANKED(
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	LIFETIME_VALUE,
	LTV_RANK
) as
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.lifetime_value,
    (
        SELECT COUNT(*)
        FROM customers c2
        WHERE c2.lifetime_value > c.lifetime_value
    ) + 1 AS ltv_rank
FROM customers c;
