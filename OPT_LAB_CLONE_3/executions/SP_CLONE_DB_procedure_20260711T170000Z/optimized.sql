CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB(
    SOURCE_DB  VARCHAR,
    CLONE_BASE VARCHAR,
    N_CLONES   NUMBER
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    clone_name STRING;
BEGIN
    -- Loop from 1 to N_CLONES creating each cloned database
    FOR i IN 1..N_CLONES DO
        clone_name := CLONE_BASE || '_' || i;

        EXECUTE IMMEDIATE
            'CREATE OR REPLACE DATABASE ' || clone_name ||
            ' CLONE ' || SOURCE_DB;
    END FOR;

    RETURN 'Created ' || N_CLONES || ' clones of ' || SOURCE_DB ||
           ' named ' || CLONE_BASE || '_1 .. ' || CLONE_BASE || '_' || N_CLONES;
END;
$$;
