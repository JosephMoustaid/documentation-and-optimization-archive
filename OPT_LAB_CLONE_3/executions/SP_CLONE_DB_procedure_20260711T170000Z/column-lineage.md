# Parameter / variable lineage — SP_CLONE_DB

Because this is a stored procedure (not a view), “column lineage” is interpreted as **parameter and variable lineage**.

## Inputs
- `SOURCE_DB` (VARCHAR): database to clone
- `CLONE_BASE` (VARCHAR): base name used to build each clone name
- `N_CLONES` (NUMBER): number of clones to create

## Derived values
- `i` (loop index): iterates from `1` to `N_CLONES`
- `clone_name` (STRING): `CLONE_BASE || '_' || i`

## Side effects (dynamic SQL)
The procedure executes dynamic SQL:

```sql
CREATE OR REPLACE DATABASE <clone_name> CLONE <SOURCE_DB>
```

Static dependency lineage (which databases are created/used) cannot be resolved without runtime parameter values.
