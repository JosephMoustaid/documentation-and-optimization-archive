# Optimization Report

## Target

- **Object URN:** `OPT_LAB_CLONE_5.RETAIL.SP_RECALC_ORDER_TOTALS`
- **Object Type:** `PROCEDURE`

## Status

- **Execution Status:** `FAILED`

## Applied/Attempted Change

The run attempted to execute the following SQL (preserved byte-for-byte):

```sql
CREATE OR REPLACE PROCEDURE RETAIL.SP_RECALC_ORDER_TOTALS()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    v_rows_processed NUMBER := 0;
BEGIN
    MERGE INTO orders o
    USING (
        SELECT
            oi.order_id,
            COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_total
        FROM order_items oi
        GROUP BY oi.order_id
    ) s
    ON o.order_id = s.order_id
    WHEN MATCHED THEN
        UPDATE SET o.order_total = s.order_total;

    v_rows_processed := SQLROWCOUNT;

    RETURN 'Recalculated ' || v_rows_processed || ' order totals (the slow way).';
END;
$$
```

## Failure

- **Error:** Unable to run the CREATE PROCEDURE command. You must specify the database to use by either setting the database field in the body of the request or by setting the DEFAULT_NAMESPACE property for the current user.
- **Message:** APPLY execution failed: target database not set; procedure was not created or replaced.

## Notes

- This archive captures the attempted optimized SQL and execution metadata.
- No schema/lineage artifacts are produced for procedures beyond `procedure-flow.mmd`.
