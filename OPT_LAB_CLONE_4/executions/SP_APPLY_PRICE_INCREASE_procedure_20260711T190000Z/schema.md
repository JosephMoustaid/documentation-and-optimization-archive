# Schema Context

- **Database:** OPT_LAB_CLONE_4
- **Schema filter:** ALL
- **Object referenced:** `RETAIL.SP_APPLY_PRICE_INCREASE`

## Note

Validation failed because the DDL used an unqualified procedure name (`RETAIL.SP_APPLY_PRICE_INCREASE`) without an active database context.

To validate successfully, either:

- Fully qualify the object name: `OPT_LAB_CLONE_4.RETAIL.SP_APPLY_PRICE_INCREASE`, or
- Set context prior to running the DDL:

```sql
USE DATABASE OPT_LAB_CLONE_4;
USE SCHEMA RETAIL;
```
