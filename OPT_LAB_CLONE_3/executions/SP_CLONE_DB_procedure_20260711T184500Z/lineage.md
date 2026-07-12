# Lineage

This artifact is informational for procedures.

- Creates/clones databases dynamically via `EXECUTE IMMEDIATE`.
- Inputs:
  - `SOURCE_DB` (source database to clone)
  - `CLONE_BASE` (base name for new databases)
  - `N_CLONES` (number of clones)

Because the procedure uses dynamic SQL, object-level lineage is not fully resolvable statically.
