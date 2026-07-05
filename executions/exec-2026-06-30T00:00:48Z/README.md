# Execution exec-2026-06-30T00:00:48Z

- **Timestamp:** 2026-06-30T00:00:48Z
- **Warehouse:** ADF_WH
- **Execution mode:** APPLY
- **Status:** FAILED
- **Totals:** total_objects=0, successful_executions=0, failed_executions=1

## Failed object(s)

### opt-1 — HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_ORDER_DETAILS_FULL (VIEW)

**Failure reason**

> Execution not performed in this run context; no Snowflake execution result is available.

**Message**

> The optimized definition for HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_ORDER_DETAILS_FULL was received but not executed in this environment. Please run the provided CREATE OR REPLACE VIEW statement in your Snowflake account to apply the optimization.

**Executed SQL**

```sql
CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_ORDER_DETAILS_FULL AS
SELECT
    /* Base order fields */
    o.PAYLOAD:order_id::STRING      AS ORDER_ID,
    o.PAYLOAD:customer_id::STRING   AS CUSTOMER_ID,
    o.PAYLOAD:product_id::STRING    AS PRODUCT_ID

    -- Add further extracted attributes as needed, for example:
    -- , o.PAYLOAD:order_date::TIMESTAMP_NTZ AS ORDER_DATE
    -- , o.PAYLOAD:status::STRING           AS ORDER_STATUS
    -- , o.PAYLOAD:quantity::NUMBER         AS QUANTITY
    -- , o.PAYLOAD:net_amount::NUMBER(18,2) AS NET_AMOUNT

FROM HAFID_OPTIM_CLONE_1.PIPELINE_MART.ORDERS o;
```

## Raw payload

See [`payload.json`](./payload.json).
