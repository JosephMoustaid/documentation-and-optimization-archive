CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS AS
/*
    Optimizations / fixes:
    - Fully qualified base objects for stable resolution.
    - Replaced `c.*` with an explicit, curated list of customer columns to reduce
      scan size and avoid schema-change fragility.
    - Added explicit column aliases for clarity and to avoid name collisions.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status               AS order_status,

    -- Explicit customer columns instead of c.*
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.city,
    c.state,
    c.country,

    oi.product_id,
    oi.quantity,
    oi.unit_price,

    p.product_name,
    p.category,

    pay.amount             AS payment_amount,
    pay.method             AS payment_method,
    pay.status             AS payment_status
FROM OPT_LAB_CLONE_3.RETAIL.orders       AS o
JOIN OPT_LAB_CLONE_3.RETAIL.customers    AS c
  ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_3.RETAIL.order_items  AS oi
  ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_3.RETAIL.products     AS p
  ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_3.RETAIL.payments AS pay
  ON pay.order_id = o.order_id;
