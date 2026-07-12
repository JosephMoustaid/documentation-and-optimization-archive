# Procedure Flow — `OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB`

```mermaid
flowchart TD
  A([Start]) --> B[Initialize i = 1]
  B --> C{ i <= N_CLONES ? }
  C -- Yes --> D[clone_name = CLONE_BASE || '_' || i]
  D --> E[EXECUTE IMMEDIATE: CREATE OR REPLACE DATABASE clone_name CLONE SOURCE_DB]
  E --> F[i = i + 1]
  F --> C
  C -- No --> G[RETURN summary string]
  G --> H([End])
```

## Key behaviors

- Iteratively creates/replaces `N_CLONES` database clones.
- Uses `IDENTIFIER(clone_name)` and `IDENTIFIER(SOURCE_DB)` to form safe object identifiers.
- Returns a human-readable confirmation string.
