CREATE OR REPLACE VIEW HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL AS
WITH base AS (
    SELECT
        TO_DATE(e1.PAYLOAD:"timestamp"::STRING)              AS event_date,
        e1.PAYLOAD:"user_id"::STRING                         AS user_id,
        e1.PAYLOAD:"session_id"::STRING                      AS session_id,
        LOWER(e1.PAYLOAD:"event_type"::STRING)               AS event_type
    FROM HAFID_OPTIM_CLONE_1.PIPELINE_RAW.RAW_EVENTS AS e1
    WHERE e1._LOADED_AT >= DATEADD('day', -90, CURRENT_TIMESTAMP())
)
SELECT
    event_date                                      AS EVENT_DATE,
    event_type                                      AS EVENT_TYPE,

    -- Total events per (date, type)
    COUNT(*)                                        AS TOTAL_EVENTS,

    -- Funnel stage counts
    SUM(CASE WHEN event_type LIKE '%view%'      THEN 1 ELSE 0 END) AS VIEW_EVENTS,
    SUM(CASE WHEN event_type LIKE '%cart%'      THEN 1 ELSE 0 END) AS CART_EVENTS,
    SUM(CASE WHEN event_type LIKE '%check%'     THEN 1 ELSE 0 END) AS CHECKOUT_EVENTS,
    SUM(CASE WHEN event_type LIKE '%purchase%'  THEN 1 ELSE 0 END) AS PURCHASE_EVENTS,

    -- Conversion rate from view to purchase (defensive against zero)
    CASE
        WHEN COALESCE(SUM(CASE WHEN event_type LIKE '%view%' THEN 1 ELSE 0 END), 0) > 0 THEN
            SUM(CASE WHEN event_type LIKE '%purchase%' THEN 1 ELSE 0 END)
            /
            NULLIF(SUM(CASE WHEN event_type LIKE '%view%' THEN 1 ELSE 0 END), 0)
        ELSE 0
    END                                             AS CONVERSION_RATE
FROM base
GROUP BY
    event_date,
    event_type;