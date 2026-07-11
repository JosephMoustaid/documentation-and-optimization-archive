create or replace view V_ORDER_DETAILS(
	ORDER_ID,
	ORDER_DATE,
	STATUS,
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	EMAIL,
	COUNTRY,
	SIGNUP_DATE,
	IS_ACTIVE,
	LIFETIME_VALUE,
	PRODUCT_ID,
	QUANTITY,
	UNIT_PRICE,
	PRODUCT_NAME,
	CATEGORY,
	PAYMENT_AMOUNT,
	PAYMENT_METHOD,
	PAYMENT_STATUS
) as
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.*,                                               -- pulls every customer column
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    pay.amount        AS payment_amount,
    pay.method        AS payment_method,
    pay.status        AS payment_status
FROM orders      o
JOIN customers   c   ON c.customer_id = o.customer_id
JOIN order_items oi  ON oi.order_id   = o.order_id
JOIN products    p   ON p.product_id  = oi.product_id
LEFT JOIN payments pay ON pay.order_id = o.order_id;
