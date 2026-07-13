# Optimization report — V_RECENT_ACTIVE_CATALOG

## Execution
- **Execution ID:** exec-2026-07-11T22:30:00Z
- **Object:** `OPT_LAB_CLONE_4.RETAIL.V_RECENT_ACTIVE_CATALOG`
- **Status:** SUCCESS

## Before vs after (high level)

### 1) Category predicate rewrite
- **Before:** `p.category ILIKE 'electronics'`
- **After:** `UPPER(p.category) = 'ELECTRONICS'`

**Benefit:** deterministic comparison; can be fast if `category` values are normalized.

**Caution:** Applying `UPPER()` to the column can reduce pruning/optimization benefits (still a function on the column) and may not match the original semantics in edge cases (spaces, locale, etc.). If case-insensitive matching with no function on the column is desired, prefer normalizing the stored values or using collation/ILIKE as appropriate.

### 2) Current-year date filtering remains SARGable
- `i.last_restocked` is filtered using a range predicate:
  - `>= start_of_year` and `< start_of_next_year`

**Benefit:** avoids `YEAR(i.last_restocked)` which would prevent partition pruning and can increase scan cost.

### 3) Fully qualified references
- Tables are referenced as `OPT_LAB_CLONE_4.RETAIL.<table>`

**Benefit:** stability across session context and clearer lineage.

## Resulting SQL
See `optimized.sql`.
