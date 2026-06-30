CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
/*
  Optimized VIEW: VW_EVENT_FUNNEL

  Assumptions (based on partial original definition and common patterns):
  - RAW_EVENTS.PAYLOAD is a VARIANT containing at least: "timestamp", "user_id",
    "event_type", and "session_id" fields.
  - Funnel steps are inferred from event_type string patterns: '%view%', '%cart%',
    '%check%', '%purchase%'.
  - We measure counts of users hitting each step per EVENT_DATE and
    compute a conversion rate (purchase / view) per day.

  Key optimizations:
  - Single pass over RAW_EVENTS with CASE expressions instead of multiple scans.
  - Push down 90‑day filter on _LOADED_AT.
  - Extract and normalize event fields once in a CTE, avoiding repeated casts.
  - Use DATE(PAYLOAD:timestamp::timestamp_ntz) for robust date extraction.
*/
WITH events_normalized AS (
    SELECT
        /* Normalize timestamp to date */
        TO_DATE(PAYLOAD:"timestamp"::TIMESTAMP_NTZ) AS EVENT_DATE,

        /* Basic identifiers */
        PAYLOAD:"user_id"::STRING      AS USER_ID,
        LOWER(PAYLOAD:"event_type"::STRING) AS EVENT_TYPE,
        PAYLOAD:"session_id"::STRING   AS SESSION_ID
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
),

funnel_flags AS (
    SELECT
        EVENT_DATE,
        USER_ID,
        SESSION_ID,

        /*
          Step flags per (date, user, session).
          Using IFF to keep expressions simple and SARGable on EVENT_TYPE.
        */
        IFF(EVENT_TYPE LIKE '%view%'     , 1, 0) AS IS_VIEW,
        IFF(EVENT_TYPE LIKE '%cart%'     , 1, 0) AS IS_CART,
        IFF(EVENT_TYPE LIKE '%check%'    , 1, 0) AS IS_CHECKOUT,
        IFF(EVENT_TYPE LIKE '%purchase%', 1, 0) AS IS_PURCHASE
    FROM events_normalized
),

/*
  Aggregate to daily funnel metrics.
  We count distinct users per step; adjust to sessions if needed by
  replacing COUNT(DISTINCT USER_ID) with COUNT(DISTINCT SESSION_ID).
*/
aggregated AS (
    SELECT
        EVENT_DATE,
        COUNT(DISTINCT IFF(IS_VIEW      = 1, USER_ID, NULL)) AS VIEW_USERS,
        COUNT(DISTINCT IFF(IS_CART      = 1, USER_ID, NULL)) AS CART_USERS,
        COUNT(DISTINCT IFF(IS_CHECKOUT  = 1, USER_ID, NULL)) AS CHECKOUT_USERS,
        COUNT(DISTINCT IFF(IS_PURCHASE  = 1, USER_ID, NULL)) AS PURCHASE_USERS
    FROM funnel_flags
    GROUP BY EVENT_DATE
)

SELECT
    EVENT_DATE,
    VIEW_USERS,
    CART_USERS,
    CHECKOUT_USERS,
    PURCHASE_USERS,
    /* Conversion rate from view to purchase; 0 when denominator is 0 */
    CASE
        WHEN VIEW_USERS > 0 THEN
            ROUND(PURCHASE_USERS::NUMBER / VIEW_USERS::NUMBER, 4)
        ELSE 0
    END AS CONVERSION_RATE
FROM aggregated;