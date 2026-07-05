-- Optimized SQL for HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL
-- FIX APPLIED: Removed the inner duplicate `CREATE OR REPLACE VIEW ... AS`.

CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
/*
Optimized definition for HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL

Assumptions/Reconstructions (original input was truncated/garbled):
- Source table: HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
- Relevant JSON fields in e1.PAYLOAD:
    - "user_id" (string)
    - "event_type" (string) – values containing: 'view', 'cart', 'check', 'purchase'
    - "session_id" (string)
    - "timestamp" (string/ISO) – event timestamp
- Goal of the view: build a basic funnel by day, event_type, computing counts and
  conversion rates across the funnel stages within a 90‑day window.

Key optimizations:
1) Single JSON extraction per column using SELECT aliases, avoiding repeated
   PAYLOAD:... expressions.
2) Robust casting/parsing for timestamp and date.
3) Filter on _LOADED_AT using a SARGable predicate to help pruning.
4) Clean, grouped CASE logic for funnel stage classification and conversion.
5) GROUP BY on projected columns using aliases for clarity and maintainability.
*/

WITH parsed_events AS (
    SELECT
        -- Base temporal fields
        TRY_TO_TIMESTAMP_NTZ(e1.PAYLOAD:timestamp::string) AS event_ts,
        TO_DATE(TRY_TO_TIMESTAMP_NTZ(e1.PAYLOAD:timestamp::string)) AS event_date,

        -- Core dimensions
        e1.PAYLOAD:user_id::string      AS user_id,
        LOWER(e1.PAYLOAD:event_type::string) AS event_type_norm,
        e1.PAYLOAD:session_id::string   AS session_id,

        -- Raw event_type retained for reference if needed later
        e1.PAYLOAD:event_type::string   AS event_type_raw
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD(day, -90, CURRENT_TIMESTAMP())
),

-- Map normalized event_type values to funnel stages
labeled_events AS (
    SELECT
        event_date,
        user_id,
        session_id,
        event_type_raw,
        event_ts,
        CASE
            WHEN event_type_norm LIKE '%view%'     THEN 'VIEW'
            WHEN event_type_norm LIKE '%cart%'     THEN 'CART'
            WHEN event_type_norm LIKE '%check%'    THEN 'CHECKOUT'
            WHEN event_type_norm LIKE '%purchase%' THEN 'PURCHASE'
            ELSE 'OTHER'
        END AS funnel_stage
    FROM parsed_events
    WHERE event_ts IS NOT NULL
)

SELECT
    event_date,
    funnel_stage,

    -- Basic counts per day & funnel stage
    COUNT(*)                          AS event_count,
    COUNT(DISTINCT user_id)           AS unique_users,
    COUNT(DISTINCT session_id)        AS unique_sessions,

    /*
      Conversion rate is interpreted as: for each date, fraction of
      sessions that reached this stage vs total sessions that had any
      funnel event that day.
    */
    CASE
        WHEN total_sessions_per_day > 0
            THEN unique_sessions * 1.0 / total_sessions_per_day
        ELSE 0
    END AS conversion_rate
FROM (
    SELECT
        le.event_date,
        le.funnel_stage,
        le.user_id,
        le.session_id,
        COUNT(DISTINCT le.session_id) OVER (
            PARTITION BY le.event_date
        ) AS total_sessions_per_day
    FROM labeled_events le
) s
GROUP BY
    event_date,
    funnel_stage,
    total_sessions_per_day;
