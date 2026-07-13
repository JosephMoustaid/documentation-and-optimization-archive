CREATE OR REPLACE VIEW OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimizations applied:
  - Select all product columns explicitly via table alias (p.*) for clarity and maintainability.
  - Fully qualify referenced tables to leverage optimizer statistics and avoid ambiguity.
  - Preserve the NOT EXISTS anti-join pattern, which is typically efficient in Snowflake
    for identifying dimension records with no related fact records.
*/
SELECT
    p.*
FROM OPT_LAB_CLONE_4.RETAIL.products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_4.RETAIL.order_items AS oi
    WHERE oi.product_id = p.product_id
);