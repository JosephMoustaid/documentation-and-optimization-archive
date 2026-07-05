CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_ORDER_DETAILS AS
/*
  Optimization / cleanup notes (behavior-preserving):
  - Explicitly qualified all table references for clarity and maintainability.
  - Replaced ambiguous/unparsable `c.` with `c.*` to pull all customer columns
    as clearly intended, without changing behavior.
  - Normalized join syntax and formatting; no logical changes made.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.*,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    pay.amount AS payment_amount,
    pay.method AS payment_method,
    pay.status AS payment_status
FROM OPT_LAB_CLONE_1.RETAIL.orders        AS o
JOIN OPT_LAB_CLONE_1.RETAIL.customers     AS c
    ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_1.RETAIL.order_items   AS oi
    ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_1.RETAIL.products      AS p
    ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_1.RETAIL.payments AS pay
    ON pay.order_id = o.order_id;