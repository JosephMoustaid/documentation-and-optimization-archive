# Schema

- Database: `OPT_LAB_CLONE_3`
- Schema: `RETAIL`
- Object: `SP_CLONE_DB`
- Type: `procedure`

Procedure signature (optimized):

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
