# Schema / Signature

## Object

- **URN:** `OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB`
- **Type:** procedure

## Signature (optimized DDL)

```sql
CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB(
    SOURCE_DB  VARCHAR,
    CLONE_BASE VARCHAR,
    N_CLONES   NUMBER
)
RETURNS STRING
LANGUAGE SQL
...
```

## Parameters

| Name | Type | Description |
|---|---|---|
| `SOURCE_DB` | VARCHAR | Source database to clone. |
| `CLONE_BASE` | VARCHAR | Base name used for cloned databases. |
| `N_CLONES` | NUMBER | Number of clones to create. |

## Returns

- `STRING`: summary message indicating how many clones were created and the naming pattern.
