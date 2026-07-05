CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_SALES AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references to avoid dependency on current schema search path.
  - Added explicit aliases for all tables to improve readability and maintainability.
  - Kept SELECT DISTINCT to preserve the exact rowset semantics of the original view.
  - Preserved all columns, expressions, and join conditions exactly as in the original.
*/
SELECT DISTINCT
    p.product_id,
    p.product_name,
    p.category,
    o.order_id,
    o.order_date,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total
FROM OPT_LAB_CLONE_1.RETAIL.PRODUCTS      AS p
JOIN OPT_LAB_CLONE_1.RETAIL.ORDER_ITEMS   AS oi
    ON oi.product_id = p.product_id
JOIN OPT_LAB_CLONE_1.RETAIL.ORDERS        AS o
    ON o.order_id = oi.order_id
JOIN OPT_LAB_CLONE_1.RETAIL.CUSTOMERS     AS c
    ON c.customer_id = o.customer_id;
