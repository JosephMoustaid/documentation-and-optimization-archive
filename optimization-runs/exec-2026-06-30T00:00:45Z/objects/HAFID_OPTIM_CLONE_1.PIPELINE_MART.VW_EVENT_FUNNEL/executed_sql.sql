CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
/*
  Reconstructed and optimized funnel view based on provided fragments.

  Assumptions (due to corrupted input object):
  - RAW_EVENTS.PAYLOAD is a VARIANT containing:
      - "timestamp" (string or timestamp-like)
      - "user_id" (string)
      - "event_type" (string, e.g. contains: view, cart, checkout, purchase)
      - "session_id" (string)
  - Funnel stages are derived by pattern-matching event_type text.
  - Conversion rate is defined as PURCHASE_EVENTS / VIEW_EVENTS per (event_date, user_id).

  Optimizations:
  1) Single pass over RAW_EVENTS with a 90‑day filter on _LOADED_AT.
  2) Parse and normalize payload fields once in a CTE.
  3) Use conditional aggregation instead of multiple joins/self-scans.
  4) Push down LIKE comparisons on a lowercase event_type for consistent classification.
*/

WITH parsed_events AS (
    SELECT
        TO_DATE(e1.PAYLOAD:timestamp::STRING)                         AS event_date,
        e1.PAYLOAD:user_id::STRING                                    AS user_id,
        e1.PAYLOAD:session_id::STRING                                 AS session_id,
        LOWER(e1.PAYLOAD:event_type::STRING)                           AS event_type_norm
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
      AND e1.PAYLOAD IS NOT NULL
)
SELECT
    event_date,
    user_id,
    session_id,
    /* funnel stage counts */
    SUM(CASE WHEN event_type_norm LIKE '%view%'      THEN 1 ELSE 0 END) AS view_events,
    SUM(CASE WHEN event_type_norm LIKE '%cart%'      THEN 1 ELSE 0 END) AS cart_events,
    SUM(CASE WHEN event_type_norm LIKE '%check%'     THEN 1 ELSE 0 END) AS checkout_events,
    SUM(CASE WHEN event_type_norm LIKE '%purchase%'  THEN 1 ELSE 0 END) AS purchase_events,
    /* conversion rate defined as purchases per view; safe divide */
    CASE
        WHEN SUM(CASE WHEN event_type_norm LIKE '%view%' THEN 1 ELSE 0 END) > 0 THEN
            ROUND(
                SUM(CASE WHEN event_type_norm LIKE '%purchase%' THEN 1 ELSE 0 END)
                /
                NULLIF(
                    SUM(CASE WHEN event_type_norm LIKE '%view%' THEN 1 ELSE 0 END),
                    0
                )
            , 2)
        ELSE 0
    END AS conversion_rate
FROM parsed_events
GROUP BY
    event_date,
    user_id,
    session_id;
