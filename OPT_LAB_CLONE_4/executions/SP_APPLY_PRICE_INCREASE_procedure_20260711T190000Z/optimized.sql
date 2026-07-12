CREATE OR REPLACE PROCEDURE RETAIL.SP_APPLY_PRICE_INCREASE(
    cat VARCHAR,
    pct NUMBER
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_rows_affected NUMBER;
BEGIN
    -- Set-based update instead of cursor loop
    UPDATE products
       SET unit_price = ROUND(unit_price * (1 + :pct / 100.0), 2)
     WHERE category = :cat;

    -- ROWCOUNT returns number of rows affected by the last DML statement
    v_rows_affected := SQLROWCOUNT;

    RETURN 'Raised price on ' || v_rows_affected || ' products (set-based, optimized).';
END;
$$;
