CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS AS
SELECT
    o.order_id,
    o.order_date,
    o.status,
    -- Explicit customer columns (adjust to actual schema as needed)
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.address,
    c.city,
    c.state,
    c.postal_code,
    c.country,
    -- Order item details
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    -- Product details
    p.product_name,
    p.category,
    -- Payment details
    pay.amount AS payment_amount,
    pay.method AS payment_method,
    pay.status AS payment_status
FROM OPT_LAB_CLONE_4.RETAIL.orders        AS o
JOIN OPT_LAB_CLONE_4.RETAIL.customers     AS c
  ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_4.RETAIL.order_items   AS oi
  ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_4.RETAIL.products      AS p
  ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.payments AS pay
  ON pay.order_id = o.order_id;
