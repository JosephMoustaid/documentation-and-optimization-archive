CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_SALES AS
/*
  Optimization notes (behavior-preserving):
  - Kept DISTINCT to preserve exact output semantics in case of upstream duplicates.
  - Standardized join and column aliasing for readability and maintainability.
  - Kept explicit line_total expression to avoid any change in numeric behavior.
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
FROM products      AS p
JOIN order_items   AS oi
    ON oi.product_id = p.product_id
JOIN orders        AS o
    ON o.order_id = oi.order_id
JOIN customers     AS c
    ON c.customer_id = o.customer_id;
