# Lineage (high-level)

This artifact documents the *operational* lineage/impact of the procedure.

## Reads
- `source_db` (STRING parameter): interpreted as the name of an existing database to clone.

## Writes / Side effects
- Creates or replaces databases named: `<clone_base>_1 .. <clone_base>_<n_clones>`
- Operation executed via dynamic SQL: `CREATE OR REPLACE DATABASE <clone_name> CLONE <source_db>`

## Notes
- Because object names are supplied at runtime, full static lineage cannot be enumerated.
- Use caution: database cloning is a high-impact DDL operation.
