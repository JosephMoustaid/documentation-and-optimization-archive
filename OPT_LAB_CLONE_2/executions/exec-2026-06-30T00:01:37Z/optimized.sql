-- Object: OPT_LAB_CLONE_2.RETAIL.V_NEVER_ORDERED_PRODUCTS
-- Type: VIEW
-- Execution: exec-2026-06-30T00:01:37Z

CREATE OR REPLACE VIEW OPT_LAB_CLONE_2.RETAIL.V_NEVER_ORDERED_PRODUCTS AS
/*
  Optimizations (behavior-preserving):
  - Fully qualified table references for stability and to avoid reliance on session defaults.
  - Replaced NOT IN subquery with NOT EXISTS to avoid NULL-sensitivity issues and
    to enable more efficient anti-join execution plans.
  - Kept column projection as in original (selecting all columns from PRODUCTS via alias p).
*/
SELECT
    p.*
FROM OPT_LAB_CLONE_2.RETAIL.PRODUCTS AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OPT_LAB_CLONE_2.RETAIL.ORDER_ITEMS AS oi
    WHERE oi.product_id = p.product_id
);
