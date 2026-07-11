CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_CLONE_DB(
    SOURCE_DB   VARCHAR,
    CLONE_BASE  VARCHAR,
    N_CLONES    NUMBER
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_cmd   STRING;
BEGIN
    -- Build a single dynamic statement that contains all CREATE DATABASE commands
    -- for the requested number of clones. This removes the explicit procedural loop.
    SELECT LISTAGG(
               'CREATE OR REPLACE DATABASE ' ||
               CLONE_BASE || '_' || seq::STRING ||
               ' CLONE ' || SOURCE_DB || ';',
               ' '
           )
    INTO :v_cmd
    FROM (
        SELECT SEQ4() + 1 AS seq
        FROM TABLE(GENERATOR(ROWCOUNT => :N_CLONES))
    );

    -- Execute the concatenated CREATE DATABASE statements
    EXECUTE IMMEDIATE :v_cmd;

    RETURN 'Created ' || N_CLONES || ' clones of ' || SOURCE_DB
           || ' named ' || CLONE_BASE || '1 .. ' || CLONE_BASE || '' || N_CLONES;
END;
$$;
