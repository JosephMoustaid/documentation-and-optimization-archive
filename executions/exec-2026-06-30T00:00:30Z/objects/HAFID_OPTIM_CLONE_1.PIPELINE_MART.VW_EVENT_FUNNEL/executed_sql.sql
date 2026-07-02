CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
/*
  Assumed intent (reconstructed from partial, corrupted definition):
  - Build an event funnel by day and user, based on RAW_EVENTS.
  - Events are identified via EVENT_TYPE pattern matching on PAYLOAD.
  - Compute a simple conversion rate across the funnel stages.

  Key optimizations vs the inferred original:
  - Single pass over RAW_EVENTS with explicit event_type extraction.
  - Use conditional aggregation (SUM of stage flags) instead of nested CASEs.
  - Restrict scan to last 90 days via _LOADED_AT predicate, preserving selectivity.
  - Avoid repeated LIKE evaluations in multiple CASEs by deriving EVENT_TYPE once.
  - Group by explicit columns (USER_ID, EVENT_DATE) instead of positional indexes.

  NOTE: This is a best-effort optimized reconstruction; adjust JSON paths and
        patterns (e.g. $.event_type, $.user_id) to match your actual RAW_EVENTS
        structure.
*/
WITH base_events AS (
    SELECT
        /* Extract core attributes once */
        TO_DATE(e1.PAYLOAD:timestamp::STRING) AS event_date,
        e1.PAYLOAD:user_id::STRING           AS user_id,
        LOWER(e1.PAYLOAD:event_type::STRING) AS event_type_normalized,
        e1.PAYLOAD:session_id::STRING        AS session_id
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
),
classified_events AS (
    SELECT
        event_date,
        user_id,
        session_id,
        event_type_normalized,
        /* Stage flags (0/1) for funnel steps to enable fast aggregation) */
        CASE WHEN event_type_normalized LIKE '%view%'     THEN 1 ELSE 0 END AS is_view,
        CASE WHEN event_type_normalized LIKE '%cart%'     THEN 1 ELSE 0 END AS is_cart,
        CASE WHEN event_type_normalized LIKE '%check%'    THEN 1 ELSE 0 END AS is_checkout,
        CASE WHEN event_type_normalized LIKE '%purchase%' THEN 1 ELSE 0 END AS is_purchase
    FROM base_events
)
SELECT
    event_date,
    user_id,
    /* Funnel stage counts per user per day */
    SUM(is_view)     AS views,
    SUM(is_cart)     AS carts,
    SUM(is_checkout) AS checkouts,
    SUM(is_purchase) AS purchases,
    /*
      Simple conversion rate: purchases divided by views.
      Uses NULLIF to avoid division by zero and COALESCE to default to 0.
    */
    COALESCE(
        SUM(is_purchase) / NULLIF(SUM(is_view), 0),
        0
    ) AS conversion_rate
FROM classified_events
GROUP BY
    event_date,
    user_id;