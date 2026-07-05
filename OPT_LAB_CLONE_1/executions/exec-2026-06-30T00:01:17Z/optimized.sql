CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_ORDER_DETAILS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified base tables to avoid reliance on current database/schema context.
  - Reordered joins to group required INNER JOINs together, keeping the LEFT JOIN last for clarity.
  - Preserved c.* (all customer columns) as in the original definition, including column order.
  - Kept join types and predicates identical to maintain row counts and null-handling semantics.
*/
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.*,                 -- pulls every customer column (unchanged behavior)
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    p.product_name,
    p.category,
    pay.amount AS payment_amount,
    pay.method AS payment_method,
    pay.status AS payment_status
FROM OPT_LAB_CLONE_1.RETAIL.ORDERS         AS o
JOIN OPT_LAB_CLONE_1.RETAIL.CUSTOMERS      AS c
    ON c.customer_id = o.customer_id
JOIN OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS    AS oi
    ON oi.order_id = o.order_id
JOIN OPT_LAB_CLONE_1.RETAIL.PRODUCTS       AS p
    ON p.product_id = oi.product_id
LEFT JOIN OPT_LAB_CLONE_1.RETAIL.PAYMENTS  AS pay
    ON pay.order_id = o.order_id;
