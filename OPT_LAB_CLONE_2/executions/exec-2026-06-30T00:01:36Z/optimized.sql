-- Execution: exec-2026-06-30T00:01:36Z
-- Object: OPT_LAB_CLONE_2.RETAIL.V_PRODUCT_SALES (VIEW)
-- Warehouse: ADF_WH
-- Mode: APPLY

CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_PRODUCT_SALES AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references for stability and to avoid reliance on session defaults.
  - Kept DISTINCT to preserve exact row semantics of the original view.
  - Added comments suggesting potential indexing/cluster keys without changing objects.
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
