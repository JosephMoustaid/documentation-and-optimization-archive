# Column Lineage

This execution optimized a **Snowflake stored procedure** (`OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB`).

Procedures do not produce a tabular result set with stable output columns like a view, so **column-level lineage is not applicable**.

## Captured inputs/outputs

- Inputs (parameters): `SOURCE_DB`, `CLONE_BASE`, `N_CLONES`
- Output (return value): `STRING` message summarizing what was created
