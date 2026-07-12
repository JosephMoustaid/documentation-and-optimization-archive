# Lineage (procedure)

This procedure performs DDL actions (database clones). It does not select from or write to tables directly.

## Inputs

- `SOURCE_DB` (database name)
- `CLONE_BASE` (target database name prefix)
- `N_CLONES` (count)

## Side effects / Outputs

- Creates or replaces databases named:
  - `${CLONE_BASE}_1` .. `${CLONE_BASE}_${N_CLONES}`
- Each target database is a `CLONE` of `${SOURCE_DB}`.

## Notes

- Uses dynamic SQL via `EXECUTE IMMEDIATE`.
- Uses `IDENTIFIER(...)` to safely treat input strings as object identifiers.
