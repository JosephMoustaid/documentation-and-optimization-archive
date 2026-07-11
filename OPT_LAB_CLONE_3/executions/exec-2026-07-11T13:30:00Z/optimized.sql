CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE(
    CAT VARCHAR,
    PCT FLOAT
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_rows_updated NUMBER := 0;
BEGIN
    -- Set-based price increase for all products in the given category
    UPDATE OPT_LAB_CLONE_3.RETAIL.products
    SET unit_price = ROUND(unit_price * (1 + :PCT / 100.0), 2)
    WHERE category = :CAT;

    -- Get number of affected rows from the last DML statement
    SELECT ROW_COUNT
    INTO :v_rows_updated
    FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

    RETURN 'Raised price on ' || v_rows_updated || ' products (set-based, optimized).';
END;
$$;
