CREATE OR REPLACE VIEW OPT_LAB_CLONE_3.RETAIL.V_ORDER_DETAILS AS
/*
    Optimizations / fixes:
    - Replaced ambiguous "c." shorthand with explicit column list to avoid accidental
      schema bloat and reduce bytes scanned.
    - Fully qualified base tables with database and schema for stable name resolution.
    - Added explicit column aliases for clarity and to prevent name collisions.

    NOTE:
    - This definition failed validation in DRY_RUN due to invalid identifier C.PHONE.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status              AS order_status,

    -- Explicit customer columns instead of "c.*" to control projection size
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.status              AS customer_status,

    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,

    p.product_name,
    p.category,

    pay.amount            AS payment_amount,
    pay.method            AS payment_method,
    pay.status            AS payment_status
FROM OPT_LAB_CLONE_3.RETAIL.orders       AS o
JOIN OPT_LAB_CLONE_3.RETAIL.customers    AS c
  ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_3.RETAIL.order_items  AS oi
  ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_3.RETAIL.products     AS p
  ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_3.RETAIL.payments AS pay
  ON pay.order_id = o.order_id;
