CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_ORDER_DETAILS AS
/* 
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid reliance on session database/schema.
  - Preserved c.* in the projection to keep the exact original output schema and
    column ordering for customer fields.
  - Join types and predicates are identical to the original definition:
      * INNER JOINs: ORDERS ↔ CUSTOMERS, ORDERS ↔ ORDER_ITEMS, ORDER_ITEMS ↔ PRODUCTS
      * LEFT JOIN:  ORDERS ↔ PAYMENTS
  - No filters or expressions were added or removed; behavior, row counts, and
    null-handling semantics remain unchanged.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.*,  -- pulls every customer column
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    pay.amount AS payment_amount,
    pay.method AS payment_method,
    pay.status AS payment_status
FROM OPT_LAB_CLONE_1.RETAIL.ORDERS        AS o
JOIN OPT_LAB_CLONE_1.RETAIL.CUSTOMERS     AS c
    ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS   AS oi
    ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_1.RETAIL.PRODUCTS      AS p
    ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_1.RETAIL.PAYMENTS AS pay
    ON pay.order_id = o.order_id;