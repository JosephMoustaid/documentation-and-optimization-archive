# View definition diff

**Object:** `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL`

## Summary of key changes
- Output schema changed from `(event_date, funnel_stage, event_count, conversion_rate)` to per-session/per-user conditional aggregates: `view_events, cart_events, checkout_events, purchase_events, conversion_rate`.
- Grain changed from daily per funnel_stage to daily per `(user_id, session_id)`.
- Conversion rate definition updated to `purchase_events / view_events` with safe division and rounding.
- Classification refactored from a CASE-derived `funnel_stage` + GROUP BY to conditional aggregation in a single SELECT.

## Previous definition
```sql
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
    CASE
        WHEN funnel_stage = 'VIEW' THEN 0::NUMBER
        ELSE 0::NUMBER
    END AS CONVERSION_RATE
FROM classified_events
WHERE funnel_stage IN ('VIEW', 'CART', 'CHECKOUT', 'PURCHASE')
GROUP BY
    event_date,
    funnel_stage;
```

## Executed SQL
```sql
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
    SUM(CASE WHEN event_type_norm LIKE '%view%'      THEN 1 ELSE 0 END) AS view_events,
    SUM(CASE WHEN event_type_norm LIKE '%cart%'      THEN 1 ELSE 0 END) AS cart_events,
    SUM(CASE WHEN event_type_norm LIKE '%check%'     THEN 1 ELSE 0 END) AS checkout_events,
    SUM(CASE WHEN event_type_norm LIKE '%purchase%'  THEN 1 ELSE 0 END) AS purchase_events,
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
```
