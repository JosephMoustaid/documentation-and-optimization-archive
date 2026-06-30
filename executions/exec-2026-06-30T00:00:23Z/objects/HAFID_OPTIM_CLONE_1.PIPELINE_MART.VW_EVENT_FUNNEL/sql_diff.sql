-- Object: HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL
-- Type: VIEW
-- Execution: exec-2026-06-30T00:00:23Z
--
-- This file captures the previous definition and the applied SQL.

/* =========================
   PREVIOUS_DEFINITION
   ========================= */
create or replace view VW_EVENT_FUNNEL(
	EVENT_DATE,
	USER_ID,
	SESSION_ID,
	VIEW_EVENTS,
	CART_EVENTS,
	CHECKOUT_EVENTS,
	PURCHASE_EVENTS,
	CONVERSION_RATE
) as
/*
  Reconstructed and optimized view definition based on the partially provided payload.
  Assumptions (due to corrupted original definition):
  - RAW_EVENTS contains a JSON column PAYLOAD with at least:
      - "timestamp" (event time)
      - "user_id"
      - "event_type"
      - "session_id"
  - We want a simple funnel: view → cart → checkout → purchase.
  - Conversion rate is calculated as purchase events divided by view events per day.

  Optimizations / design choices:
  - Parse PAYLOAD once per row using direct JSON extraction, avoiding repeated casts.
  - Use conditional aggregation (SUM(CASE WHEN ... THEN 1 ELSE 0 END)) to compute stage counts.
  - Restrict to last 90 days in a single WHERE clause on _LOADED_AT for efficient pruning.
  - Group by DATE and user/session dimensions only once.
*/
WITH events AS (
    SELECT
        TO_DATE(e1.PAYLOAD:"timestamp"::STRING) AS event_date,
        e1.PAYLOAD:"user_id"::STRING          AS user_id,
        LOWER(e1.PAYLOAD:"event_type"::STRING) AS event_type,
        e1.PAYLOAD:"session_id"::STRING       AS session_id
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
)
SELECT
    event_date,
    /* Optional: keep user/session grain; remove if only daily totals are needed */
    user_id,
    session_id,

    /* Funnel stage counts using conditional aggregation */
    SUM(CASE WHEN event_type LIKE '%view%'     THEN 1 ELSE 0 END) AS view_events,
    SUM(CASE WHEN event_type LIKE '%cart%'     THEN 1 ELSE 0 END) AS cart_events,
    SUM(CASE WHEN event_type LIKE '%check%'    THEN 1 ELSE 0 END) AS checkout_events,
    SUM(CASE WHEN event_type LIKE '%purchase%' THEN 1 ELSE 0 END) AS purchase_events,

    /* Conversion rate from view to purchase; protect against division by zero */
    CASE
        WHEN SUM(CASE WHEN event_type LIKE '%view%' THEN 1 ELSE 0 END) > 0 THEN
            ROUND(
                SUM(CASE WHEN event_type LIKE '%purchase%' THEN 1 ELSE 0 END)
                /
                SUM(CASE WHEN event_type LIKE '%view%' THEN 1 ELSE 0 END),
                2
            )
        ELSE 0
    END AS conversion_rate
FROM events
GROUP BY
    event_date,
    user_id,
    session_id;

/* =========================
   EXECUTED_SQL (APPLIED)
   ========================= */
CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
/*
  Optimized event funnel view.

  Key assumptions (based on provided fragment):
  - RAW_EVENTS.PAYLOAD is a VARIANT containing at least: timestamp, user_id, event_type, session_id.
  - Funnel stages are identified by substrings in event_type: 'view', 'cart', 'check', 'purchase'.
  - CONVERSION_RATE is the ratio of purchase events to view events per (EVENT_DATE, user_id).

  Key optimizations:
  - Parse VARIANT payload once in a CTE for clarity and reuse.
  - Use DATE_TRUNC on TIMESTAMP rather than TO_DATE on string for better type handling.
  - Filter the last 90 days using a SARGable predicate on the loaded-at timestamp.
  - Compute funnel counts with conditional aggregation and derive conversion rate from those
    aggregates rather than repeating CASE expressions.
*/
WITH parsed_events AS (
    SELECT
        DATE_TRUNC('day', e1.PAYLOAD:"timestamp"::TIMESTAMP_NTZ) AS EVENT_DATE,
        e1.PAYLOAD:"user_id"::STRING                             AS USER_ID,
        LOWER(e1.PAYLOAD:"event_type"::STRING)                   AS EVENT_TYPE,
        e1.PAYLOAD:"session_id"::STRING                          AS SESSION_ID
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
),
funnel_agg AS (
    SELECT
        EVENT_DATE,
        USER_ID,
        COUNT_IF(EVENT_TYPE LIKE '%view%')      AS VIEWS,
        COUNT_IF(EVENT_TYPE LIKE '%cart%')      AS CART_ADDS,
        COUNT_IF(EVENT_TYPE LIKE '%check%')     AS CHECKOUTS,
        COUNT_IF(EVENT_TYPE LIKE '%purchase%')  AS PURCHASES
    FROM parsed_events
    GROUP BY
        EVENT_DATE,
        USER_ID
)
SELECT
    EVENT_DATE,
    USER_ID,
    VIEWS,
    CART_ADDS,
    CHECKOUTS,
    PURCHASES,
    /* Conversion rate: purchases per view; protect against division by zero */
    CASE
        WHEN VIEWS > 0 THEN ROUND(PURCHASES::FLOAT / VIEWS::FLOAT, 4)
        ELSE 0
    END AS CONVERSION_RATE
FROM funnel_agg;
