CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_ORDER_DETAILS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid dependence on session database/schema.
  - Added explicit table aliases for clarity and maintainability.
  - Retained c.* to preserve the exact output schema and behavior.
  - LEFT JOIN for payments preserved to maintain original row-retention semantics.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.*,  -- pulls every customer column (preserved for functional equivalence)
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    pay.amount AS payment_amount,
    pay.method AS payment_method,
    pay.status AS payment_status
FROM OPT_LAB_CLONE_2.RETAIL.ORDERS        AS o
JOIN OPT_LAB_CLONE_2.RETAIL.CUSTOMERS     AS c
    ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_2.RETAIL.ORDER_ITEMS   AS oi
    ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_2.RETAIL.PRODUCTS      AS p
    ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_2.RETAIL.PAYMENTS AS pay
    ON pay.order_id = o.order_id;
