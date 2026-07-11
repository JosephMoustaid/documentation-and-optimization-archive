# OPT_LAB_CLONE_3 — Execution exec-2026-07-11T15:45:00Z

This folder contains persisted optimization artifacts for a single execution.

- **Database:** OPT_LAB_CLONE_3
- **Warehouse:** ADF_WH
- **Execution mode:** DRY_RUN
- **Execution status:** SUCCESS
- **Timestamp:** 2026-07-11T15:45:00Z

## Contents

- `execution.json` — raw execution payload + metadata.
- `previous.sql` — original object definition.
- `optimized.sql` — proposed optimized definition (validated via EXPLAIN; not applied).
- `optimization-report.md` — human-readable optimization notes.
- `schema.mmd` — Mermaid entity graph used for documentation.
- `lineage.mmd` — Mermaid data lineage graph.
- `column-lineage.md` — column-level lineage mapping.

> DRY_RUN: All optimizations in this execution were **validated only**; no changes were applied.
