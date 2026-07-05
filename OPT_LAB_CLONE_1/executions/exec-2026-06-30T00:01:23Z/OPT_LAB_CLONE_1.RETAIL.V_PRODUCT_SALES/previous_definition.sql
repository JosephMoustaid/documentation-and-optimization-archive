CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_SALES AS
SELECT DISTINCT
 p.product_id,
 p.product_name,
 p.category,
 o.order_id,
 o.order_date,
 oi.quantity,
 oi.unit_price,
 oi.quantity * oi.unit_price AS line_total
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id;
