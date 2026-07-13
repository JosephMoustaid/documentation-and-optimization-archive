create or replace view V_ORDER_DETAILS(
	ORDER_ID,
	ORDER_DATE,
	ORDER_STATUS,
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
	PRODUCT_UNIT_PRICE,
	PRODUCT_ACTIVE_FLAG,
	PAYMENT_AMOUNT,
	PAYMENT_METHOD,
	PAYMENT_STATUS,
	PAYMENT_TIMESTAMP
) as
SELECT
    -- Order-level attributes
    o.order_id,
    o.order_date,
    o.status AS order_status,

    -- Customer attributes (from actual CUSTOMERS schema)
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    c.signup_date,
    c.is_active,
    c.lifetime_value,

    -- Order item details
    oi.product_id,
    oi.quantity,
    oi.unit_price,

    -- Product attributes
    p.product_name,
    p.category,
    p.unit_price       AS product_unit_price,
    p.active_flag      AS product_active_flag,

    -- Payment details
    pay.amount         AS payment_amount,
    pay.method         AS payment_method,
    pay.status         AS payment_status,
    pay.paid_at        AS payment_timestamp
FROM OPT_LAB_CLONE_4.RETAIL.orders       AS o
JOIN OPT_LAB_CLONE_4.RETAIL.customers    AS c
  ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_4.RETAIL.order_items  AS oi
  ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_4.RETAIL.products     AS p
  ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.payments AS pay
  ON pay.order_id = o.order_id;
