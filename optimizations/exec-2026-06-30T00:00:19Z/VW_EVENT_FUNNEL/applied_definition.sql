CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
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