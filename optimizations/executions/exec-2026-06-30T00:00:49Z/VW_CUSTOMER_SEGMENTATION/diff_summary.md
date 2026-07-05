# Diff summary — VW_CUSTOMER_SEGMENTATION

## Object

- `HAFID_OPTIM_CLONE_1.PIPELINE_MART.VW_CUSTOMER_SEGMENTATION` (VIEW)

## High-level changes (previous → executed)

1. **CTE structure**
   - Previous: single CTE `agg_sales` aggregating `FACT_SALES` and grouping by **(CUSTOMER_ID, CUSTOMER_REGION, CUSTOMER_TIER)**.
   - Executed: two-step approach with `filtered_sales` (applies STATUS filter once) then `customer_agg` grouped by **CUSTOMER_ID**.

2. **Segmentation attribute selection**
   - Previous: preserves `CUSTOMER_REGION` and `CUSTOMER_TIER` by including them in the GROUP BY.
   - Executed: assumes region/tier are consistent per customer and uses `MIN(CUSTOMER_REGION)` and `MIN(CUSTOMER_TIER)`.

3. **Metrics**
   - Both compute `TOTAL_ORDERS`, `LIFETIME_VALUE`, `FIRST_ORDER_DATE`, `LAST_ORDER_DATE`, and `CUSTOMER_TENURE_DAYS`.
   - Executed computes tenure using `DATEDIFF('day', ca.FIRST_ORDER_DATE, ca.LAST_ORDER_DATE)`.

4. **Filter**
   - Both filter `STATUS IN ('completed', 'shipped', 'delivered', 'processing')`.
   - Executed centralizes the filter in `filtered_sales`.

## Notes

- This file is a *human-readable* summary of differences. The full texts are stored in:
  - `previous_definition.sql`
  - `executed_sql.sql`
