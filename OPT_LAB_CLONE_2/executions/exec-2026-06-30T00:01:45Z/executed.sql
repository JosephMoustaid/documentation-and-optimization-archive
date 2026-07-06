CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_PRODUCT_SALES AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified all table references to avoid reliance on search path.
  - Retained DISTINCT to preserve exact row-count semantics, since
    duplicates could arise from upstream data issues.
  - Added explicit COALESCE-free arithmetic (unchanged) to avoid any
    change in NULL behavior for line_total.
  - Left join order as-is; joins are on primary/foreign key-like columns.

  Indexing / clustering suggestions (comment-only, not applied):
  - Consider clustering / indexing:
      * ORDER_ITEMS on (product_id, order_id)
      * ORDERS on (order_id, customer_id, order_date)
      * PRODUCTS on (product_id)
      * CUSTOMERS on (customer_id)
    to improve join performance for this view and related queries.
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
FROM OPT_LAB_CLONE_2.RETAIL.PRODUCTS      AS p
JOIN OPT_LAB_CLONE_2.RETAIL.ORDER_ITEMS   AS oi
  ON oi.product_id = p.product_id
JOIN OPT_LAB_CLONE_2.RETAIL.ORDERS        AS o
  ON o.order_id = oi.order_id
JOIN OPT_LAB_CLONE_2.RETAIL.CUSTOMERS     AS c
  ON c.customer_id = o.customer_id;
