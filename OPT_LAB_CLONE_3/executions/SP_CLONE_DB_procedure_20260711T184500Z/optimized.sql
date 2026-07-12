-- Optimized definition for OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB
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
    i          NUMBER  DEFAULT 1;
    clone_name STRING;
BEGIN
    -- Loop to create the requested number of clones
    WHILE (i <= N_CLONES) DO
        clone_name := CLONE_BASE || '_' || i::STRING;

        EXECUTE IMMEDIATE
              'CREATE OR REPLACE DATABASE ' || IDENTIFIER(clone_name)
           || ' CLONE ' || IDENTIFIER(SOURCE_DB);

        i := i + 1;
    END WHILE;

    -- Corrected return string to include the underscore and range properly
    RETURN 'Created ' || N_CLONES || ' clones of ' || SOURCE_DB
           || ' named ' || CLONE_BASE || '_1 .. ' || CLONE_BASE || '_' || N_CLONES;
END;
$$;
