-- Execution: exec-2026-06-30T00:01:13Z
-- Database: OPT_LAB_CLONE_1
-- Warehouse: ADF_WH
-- Mode: APPLY
-- Status: FAILED
-- Failure reason: Execution not performed in this run context; no Snowflake execution result is available.
-- Related prior failed run: exec-2026-06-30T00:01:11Z (OPT_LAB_CLONE_1.RETAIL.V_SUPPLIER_PERFORMANCE)

CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_PRODUCT_SALES AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified all base tables to ensure stable name resolution and
    avoid dependency on the current database/schema search path.
  - Retained DISTINCT in the SELECT list to preserve exact row cardinality
    and behavior in case of any hidden duplicates from joins.
  - Added explicit aliases for readability; no functional changes.
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
