-- execution_id: exec-2026-06-30T00:00:54Z
-- status: FAILED
-- reason: Execution not performed in this run context; no Snowflake execution result is available.
-- database: HAFID_OPTIM_CLONE_1
-- schema: PIPELINE_MART
-- warehouse: ADF_WH

CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_ORDER_DETAILS_FULL AS
/*
  Optimizations / assumptions:
  - Standardized JSON extraction using colon (:) operator and explicit CASTs.
  - Gave consistent, clear aliases for core identifiers.
  - Left structure minimal because original definition snippet is incomplete.
  - Kept projection narrow to avoid unnecessary column materialization.
*/
SELECT
    -- Order identifier extracted from VARIANT column o.PAYLOAD
    o.PAYLOAD:order_id::STRING   AS ORDER_ID,
    -- Product identifier if available in the same payload (assumption based on metadata)
    o.PAYLOAD:product_id::STRING AS PRODUCT_ID,
    -- Customer identifier if also present in o.PAYLOAD (alternative sources commented below)
    o.PAYLOAD:customer_id::STRING AS CUSTOMER_ID
FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.SRC_ORDERS o;

/*
Alternative mappings (uncomment / adapt if schema differs):

-- If customer_id is stored in c.PAYLOAD, and product_id in p.PAYLOAD:
-- FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.SRC_ORDERS   o
-- JOIN HAFID_OPTIM_CLONE_1.PIPELINE_MART.SRC_CUSTOMERS c
--   ON o.PAYLOAD:customer_id::STRING = c.PAYLOAD:customer_id::STRING
-- JOIN HAFID_OPTIM_CLONE_1.PIPELINE_MART.SRC_PRODUCTS  p
--   ON o.PAYLOAD:product_id::STRING = p.PAYLOAD:product_id::STRING;
*/
