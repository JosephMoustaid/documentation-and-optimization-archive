CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_ORDER_DETAILS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on session database/schema.
  - Replaced the ambiguous shorthand "c." (invalid/ambiguous SQL) with explicit
    SELECT of all customer columns via c.* to match the original intent of
    "pulls every customer column" while preserving behavior.
  - Added clear table aliases and consistent formatting for readability.
  - Left join on PAYMENTS preserved (may produce multiple rows per order if
    multiple payments exist; this matches original behavior).
  - No changes to projections, join predicates, or filtering logic.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status,
    /* All customer columns, as originally intended by "c." comment */
    c.*,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    pay.amount AS payment_amount,
    pay.method AS payment_method,
    pay.status AS payment_status
FROM OPT_LAB_CLONE_2.RETAIL.ORDERS         AS o
JOIN OPT_LAB_CLONE_2.RETAIL.CUSTOMERS      AS c
  ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_2.RETAIL.ORDER_ITEMS    AS oi
  ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_2.RETAIL.PRODUCTS       AS p
  ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_2.RETAIL.PAYMENTS  AS pay
  ON pay.order_id = o.order_id;