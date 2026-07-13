# Summary — V_RECENT_ACTIVE_CATALOG

- **Execution ID:** exec-2026-07-11T22:30:00Z
- **Timestamp:** 2026-07-11T22:30:00Z
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG` (view)
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** SUCCESS

## What changed
- Preserved fully-qualified object references.
- Kept **SARGable** date filtering on `i.last_restocked` using a `[start_of_year, start_of_next_year)` range.
- Category filtering was rewritten from `ILIKE 'electronics'` to `UPPER(p.category) = 'ELECTRONICS'`.

## Notes / risk
- `UPPER(p.category) = 'ELECTRONICS'` is only equivalent to `ILIKE 'electronics'` when category values are stored consistently (no leading/trailing spaces; no mixed casing variants beyond case). If you require true case-insensitive matching on arbitrary strings, consider retaining `ILIKE`.
