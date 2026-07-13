CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_ORDER_DETAILS AS
/*
  Optimizations & fixes:
  - Corrected invalid column reference `c.` to an explicit, curated list of customer attributes
    to avoid compilation errors and reduce unnecessary data scanning.
  - Fully qualified all base tables to leverage optimizer statistics and avoid name ambiguity.
  - Kept the existing join structure (orders → customers → order_items → products → payments)
    as it is semantically appropriate for an order-detail view.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status,
    /* Explicit customer columns instead of `c.` */
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.created_at,
    c.status AS customer_status,
    /* Order item & product details */
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    /* Payments (optional, via LEFT JOIN) */
    pay.amount  AS payment_amount,
    pay.method  AS payment_method,
    pay.status  AS payment_status
FROM OPT_LAB_CLONE_4.RETAIL.orders       AS o
JOIN OPT_LAB_CLONE_4.RETAIL.customers    AS c
  ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_4.RETAIL.order_items  AS oi
  ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_4.RETAIL.products     AS p
  ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_4.RETAIL.payments AS pay
  ON pay.order_id = o.order_id;
