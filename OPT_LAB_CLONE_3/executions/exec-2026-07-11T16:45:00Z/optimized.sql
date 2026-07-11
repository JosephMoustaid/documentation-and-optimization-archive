CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_APPLY_PRICE_INCREASE(
    CAT VARCHAR,
    PCT FLOAT
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    n NUMBER;
BEGIN
    -- Set-based update instead of cursor loop
    UPDATE OPT_LAB_CLONE_3.RETAIL.PRODUCTS
    SET UNIT_PRICE = ROUND(UNIT_PRICE * (1 + :PCT / 100.0), 2)
    WHERE CATEGORY = :CAT;

    -- Number of rows updated
    n := SQLROWCOUNT;

    RETURN 'Raised price on ' || n || ' products (set-based).';
END;
$$;
