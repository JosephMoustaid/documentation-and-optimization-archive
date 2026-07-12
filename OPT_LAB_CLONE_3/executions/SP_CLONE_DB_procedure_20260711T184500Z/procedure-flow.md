# Procedure Flow: SP_CLONE_DB

```text
1. Initialize counter i = 1
2. WHILE i <= N_CLONES
   2.1 clone_name = CLONE_BASE || '_' || i
   2.2 EXECUTE IMMEDIATE: CREATE OR REPLACE DATABASE <clone_name> CLONE <SOURCE_DB>
   2.3 i = i + 1
3. RETURN status string indicating created clones and range
```

Notes:
- Uses `IDENTIFIER()` to safely inject object identifiers for database names.
- Runs in `DRY_RUN` validation mode for this execution (no changes applied).
