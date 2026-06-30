# Optimization Artifact: VW_EVENT_FUNNEL

- **Execution ID:** `exec-2026-06-30T00:00:19Z`
- **Warehouse:** `ADF_WH`
- **Execution mode:** `APPLY`
- **Object URN:** `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL`
- **Object type:** `VIEW`
- **Task ID:** `opt-1`
- **Status:** `SUCCESS`
- **Execution time:** `140 ms`
- **Timestamp:** `2026-06-30T00:00:19Z`

## Summary
This artifact captures the applied optimization for the view `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_EVENT_FUNNEL`.

Key characteristics of the optimized design:
- Single pass over `PIPELINE_RAW.RAW_EVENTS`.
- JSON fields extracted once in a CTE (`events`).
- Conditional aggregation to compute funnel stage counts.
- 90-day retention filter on `_LOADED_AT` for pruning.
- Defensive conversion-rate calculation.

## Files
- `previous_definition.sql` — prior/reconstructed definition provided in the request payload.
- `applied_definition.sql` — SQL executed in APPLY mode.
- `metadata.json` — structured execution metadata.
