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
  Reconstructed and optimized funnel view based on partial definition:
  - Single pass over RAW_EVENTS with 90-day retention filter.
  - Extracts common fields (event_date, user_id, session_id, event_type) once in a CTE.
  - Uses conditional aggregation to compute funnel stage counts per date/user/session.
  - Computes conversion rate defensively using NULLIF to avoid division by zero.
  - Relies on simple LIKE filters on event_type for stage detection (view/cart/checkout/purchase).
  - All transformations kept in-SQL; no repeated JSON extraction in aggregates.
*/
WITH events AS (
    SELECT
        /* Normalize event timestamp to date */
        TO_DATE(e1.PAYLOAD:timestamp::string) AS event_date,
        /* Extract core attributes once */
        e1.PAYLOAD:user_id::string          AS user_id,
        e1.PAYLOAD:session_id::string       AS session_id,
        LOWER(e1.PAYLOAD:event_type::string) AS event_type
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
)
SELECT
    event_date,
    user_id,
    session_id,
    /* Funnel stage counts */
    SUM(CASE WHEN event_type LIKE '%view%'      THEN 1 ELSE 0 END) AS view_events,
    SUM(CASE WHEN event_type LIKE '%cart%'      THEN 1 ELSE 0 END) AS cart_events,
    SUM(CASE WHEN event_type LIKE '%check%'     THEN 1 ELSE 0 END) AS checkout_events,
    SUM(CASE WHEN event_type LIKE '%purchase%'  THEN 1 ELSE 0 END) AS purchase_events,
    /* Conversion rate from views to purchases */
    CASE
        WHEN SUM(CASE WHEN event_type LIKE '%view%' THEN 1 ELSE 0 END) > 0 THEN
             SUM(CASE WHEN event_type LIKE '%purchase%' THEN 1 ELSE 0 END)
             /
             NULLIF(
                 SUM(CASE WHEN event_type LIKE '%view%' THEN 1 ELSE 0 END),
                 0
             )
        ELSE 0::float
    END AS conversion_rate
FROM events
GROUP BY
    event_date,
    user_id,
    session_id;