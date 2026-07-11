CREATE OR REPLACE PROCEDURE RETAIL.SP_RECALC_ORDER_TOTALS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
    v_rows_updated NUMBER;
BEGIN
    -- Set-based recomputation of all order totals in one statement
    UPDATE orders o
    SET order_total = COALESCE(
        (
            SELECT SUM(oi.quantity * oi.unit_price)
            FROM order_items oi
            WHERE oi.order_id = o.order_id
        ),
        0
    );

    -- ROW_COUNT gives number of rows affected by the last DML
    v_rows_updated := SQLROWCOUNT;

    RETURN 'Recalculated ' || v_rows_updated || ' order totals (set-based optimized).';
END;
$$;

-- NOTE: DRY_RUN validation failed because the procedure name is not fully qualified.
-- Recommended:
-- CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_RECALC_ORDER_TOTALS() ...
