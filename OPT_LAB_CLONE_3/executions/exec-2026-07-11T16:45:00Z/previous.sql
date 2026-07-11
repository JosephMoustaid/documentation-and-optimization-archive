CREATE OR REPLACE PROCEDURE "SP_APPLY_PRICE_INCREASE"("CAT" VARCHAR, "PCT" FLOAT)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
    c CURSOR FOR SELECT product_id FROM products WHERE category = :cat;
    n NUMBER DEFAULT 0;
BEGIN
    FOR rec IN c DO
        LET pid NUMBER := rec.product_id;
        UPDATE products
           SET unit_price = ROUND(unit_price * (1 + :pct/100.0), 2)
         WHERE product_id = :pid;
        n := n + 1;
    END FOR;
    RETURN ''Raised price on '' || n || '' products (the slow way).'';
END;
';
