create or replace view VW_EVENT_FUNNEL(
	EVENT_DATE,
	USER_ID,
	VIEWS,
	CART_ADDS,
	CHECKOUTS,
	PURCHASES,
	CONVERSION_RATE
) as
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