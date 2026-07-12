# Procedure Flow: OPT_LAB_CLONE_4.RETAIL.SP_CLONE_DB

## Overview
Clones a source database multiple times, producing databases named from a base plus an incrementing suffix.

## Control flow
1. Initialize counter `i := 1`.
2. Validate inputs:
   - `source_db` non-null, non-empty
   - `clone_base` non-null, non-empty
   - `n_clones` positive
   - `n_clones <= 1000` (safety cap)
3. Normalize strings (`TRIM`) into `v_source_db`, `v_clone_base`.
4. Loop while `i <= n_clones`:
   - Compute `clone_name := v_clone_base || '_' || TO_VARCHAR(i)`
   - Execute dynamic DDL:
     - `CREATE OR REPLACE DATABASE <clone_name> CLONE <v_source_db>`
     - Uses `IDENTIFIER()` for name safety
   - Increment `i`.
5. Return a summary message describing created clones.
