CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
WITH BASE_EVENTS AS (
    SELECT
        /* Normalize event date from JSON timestamp */
        TO_DATE(e1.PAYLOAD:timestamp::STRING)          AS EVENT_DATE,

        /* Core identifiers from payload */
        e1.PAYLOAD:user_id::STRING                    AS USER_ID,
        e1.PAYLOAD:session_id::STRING                 AS SESSION_ID,

        /* Event type normalized to lower case for pattern matching */
        LOWER(e1.PAYLOAD:event_type::STRING)          AS EVENT_TYPE
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS AS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
),
SESSION_FUNNEL AS (
    /*
       Aggregate funnel events at session level.
       We keep separate counts for each funnel stage based on
       substring pattern matching, preserving original LIKE semantics.
    */
    SELECT
        EVENT_DATE,
        USER_ID,
        SESSION_ID,

        /* View stage */
        COUNT_IF(EVENT_TYPE LIKE '%view%')     AS VIEW_EVENTS,

        /* Cart stage */
        COUNT_IF(EVENT_TYPE LIKE '%cart%')     AS CART_EVENTS,

        /* Checkout stage */
        COUNT_IF(EVENT_TYPE LIKE '%check%')    AS CHECK_EVENTS,

        /* Purchase stage */
        COUNT_IF(EVENT_TYPE LIKE '%purchase%') AS PURCHASE_EVENTS
    FROM BASE_EVENTS
    GROUP BY
        EVENT_DATE,
        USER_ID,
        SESSION_ID
)
SELECT
    EVENT_DATE,
    USER_ID,
    SESSION_ID,
    VIEW_EVENTS,
    CART_EVENTS,
    CHECK_EVENTS,
    PURCHASE_EVENTS,

    /*
       Conversion rate logic inferred from original CASE pattern.
       We compute rate as purchase events over view events.
       Using explicit CASE to preserve division-by-zero behavior.
    */
    CASE
        WHEN VIEW_EVENTS > 0 THEN
            ROUND(
                (PURCHASE_EVENTS::NUMBER(38, 6) / NULLIF(VIEW_EVENTS::NUMBER(38, 6), 0))
                * 100,
                2
            )
        ELSE 0
    END AS CONVERSION_RATE
FROM SESSION_FUNNEL;
