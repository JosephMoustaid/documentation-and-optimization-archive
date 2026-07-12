CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE(
    CAT VARCHAR,
    PCT FLOAT
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    rows_affected NUMBER;
BEGIN
    -- Set-based update for all matching products
    UPDATE OPT_LAB_CLONE_3.RETAIL.PRODUCTS
    SET unit_price = ROUND(unit_price * (1 + :PCT / 100.0), 2)
    WHERE category = :CAT;

    rows_affected := SQLROWCOUNT;

    RETURN 'Raised price on ' || rows_affected || ' products (set-based update).';
END;
$$;
