# Lineage — OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES

- **Object:** OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES (VIEW)
- **Execution ID:** exec-2026-07-12T04:00:00Z

## Upstream Dependencies

- `OPT_LAB_CLONE_4.RETAIL.ORDERS` (table)

## Lineage Diagram

```mermaid
graph TD
  ORDERS[OPT_LAB_CLONE_4.RETAIL.ORDERS] -->|aggregate by ORDER_DATE| DAILY_AGG[daily_agg (CTE)]
  DAILY_AGG -->|window SUM over ORDER_DATE| V_DAILY_SALES[OPT_LAB_CLONE_4.RETAIL.V_DAILY_SALES]
```

## Notes

- The optimized view performs the daily aggregation once in a CTE (`daily_agg`) and computes the running total over the aggregated `daily_total`.
