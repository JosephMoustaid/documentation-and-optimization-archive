# Schema / Signature

## Procedure
- **Name:** OPT_LAB_CLONE_4.RETAIL.SP_CLONE_DB
- **Type:** procedure
- **Language:** SQL
- **Returns:** STRING

## Parameters
| Name | Type | Notes |
|---|---|---|
| `source_db` | STRING | Source database to clone |
| `clone_base` | STRING | Base name for clones; actual DB names become `<clone_base>_<i>` |
| `n_clones` | NUMBER | Number of clones to create (must be > 0; capped at 1000 in optimized version) |
