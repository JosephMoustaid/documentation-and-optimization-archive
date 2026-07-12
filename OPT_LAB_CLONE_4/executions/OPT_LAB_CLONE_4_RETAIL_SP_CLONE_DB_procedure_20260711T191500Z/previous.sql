-- Previous definition (as provided)
DECLARE
    i           NUMBER DEFAULT 1;
    clone_name  STRING;
BEGIN
    WHILE (i <= n_clones) DO
        clone_name := clone_base || '_' || i::STRING;
        EXECUTE IMMEDIATE
            'CREATE OR REPLACE DATABASE ' || clone_name ||
            ' CLONE ' || source_db;
        i := i + 1;
    END WHILE;
    RETURN 'Created ' || n_clones || ' clones of ' || source_db
           || ' named ' || clone_base || '_1 .. ' || clone_base || '_' || n_clones;
END;
