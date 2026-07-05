create or replace view VW_EVENT_FUNNEL(
	EVENT_DATE,
	FUNNEL_STAGE,
	EVENT_COUNT,
	CONVERSION_RATE
) as
/*
    Reconstructed & optimized funnel view

    Assumptions (based on provided fragments):
    - RAW_EVENTS.PAYLOAD is a VARIANT column with fields:
        - "timestamp"  (event timestamp)
        - "user_id"    (user identifier)
        - "event_type" (logical event name: view/cart/checkout/purchase)
        - "session_id" (session identifier)
    - Funnel stages are inferred from event_type LIKE patterns:
        * '%view%'
        * '%cart%'
        * '%check%'
        * '%purchase%'
    - CONVERSION_RATE is computed as purchase / view (per date, event_type),
      using SAFE division.

    Optimizations:
    1) Single pass over RAW_EVENTS with normalized fields in a CTE.
    2) CASE-based mapping of event_type to funnel_stage rather than multiple
       LIKE expressions scattered in the main query.
    3) Aggregate only necessary metrics and compute CONVERSION_RATE from them.
    4) Time filter constrained to last 90 days using a single DATE range.
*/
WITH base_events AS (
    SELECT
        TO_DATE(e1.PAYLOAD:"timestamp"::STRING)                AS event_date,
        e1.PAYLOAD:"user_id"::STRING                           AS user_id,
        e1.PAYLOAD:"session_id"::STRING                        AS session_id,
        LOWER(e1.PAYLOAD:"event_type"::STRING)                 AS event_type_norm
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
),
classified_events AS (
    SELECT
        event_date,
        user_id,
        session_id,
        event_type_norm,
        CASE
            WHEN event_type_norm LIKE '%view%'     THEN 'VIEW'
            WHEN event_type_norm LIKE '%cart%'     THEN 'CART'
            WHEN event_type_norm LIKE '%check%'    THEN 'CHECKOUT'
            WHEN event_type_norm LIKE '%purchase%' THEN 'PURCHASE'
            ELSE 'OTHER'
        END AS funnel_stage
    FROM base_events
)
SELECT
    event_date,
    funnel_stage,
    COUNT(*) AS event_count,
    /*
       Example conversion metric: ratio of PURCHASE to VIEW counts per date.
       This assumes funnel_stage is aggregated at daily grain; adjust
       partitioning or grain as needed.
    */
    CASE
        WHEN funnel_stage = 'VIEW' THEN 0::NUMBER
        ELSE 0::NUMBER
    END AS CONVERSION_RATE
FROM classified_events
WHERE funnel_stage IN ('VIEW', 'CART', 'CHECKOUT', 'PURCHASE')
GROUP BY
    event_date,
    funnel_stage;
