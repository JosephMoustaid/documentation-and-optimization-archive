-- Object: HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_ORDER_DETAILS_FULL
-- Type: VIEW
-- Execution mode requested: APPLY
-- Status in this run: FAILED (not executed in this environment)
-- Action required: MANUAL EXECUTION in target Snowflake account

CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_ORDER_DETAILS_FULL AS
/*
  NOTE: The original view definition snippet provided was truncated and
  syntactically incomplete. To preserve functional equivalence, this
  definition includes only the clearly specified, valid portion of the
  original logic.

  If additional columns or joins existed in the original view, they must
  be reintroduced here from the full source definition to maintain exact
  behavior.
*/
SELECT
    -- Explicit cast from VARIANT to STRING for order_id, as in original
    o.PAYLOAD:"order_id"::STRING AS ORDER_ID
FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.SOURCE_ORDERS o;
