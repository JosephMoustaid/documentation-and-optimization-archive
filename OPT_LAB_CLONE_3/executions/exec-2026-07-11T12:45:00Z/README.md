# Optimization Execution — exec-2026-07-11T12:45:00Z

This folder contains artifacts produced by the optimization pipeline execution.

- **Database:** `OPT_LAB_CLONE_3`
- **Warehouse:** `ADF_WH`
- **Mode:** `DRY_RUN`
- **Timestamp:** `2026-07-11T12:45:00Z`

## Contents

- `execution.json` — raw execution payload/results
- `previous.sql` — pre-optimization DDL
- `optimized.sql` — optimized DDL (validated via EXPLAIN in DRY_RUN)
- `optimization-report.md` — human-readable optimization notes
- `schema.mmd` — Mermaid ER-style schema snapshot (focused)
- `lineage.mmd` — Mermaid lineage graph
- `column-lineage.md` — column-level lineage notes

> Note: `procedure-flow.mmd` is only applicable for stored procedures; this execution optimized a VIEW.
