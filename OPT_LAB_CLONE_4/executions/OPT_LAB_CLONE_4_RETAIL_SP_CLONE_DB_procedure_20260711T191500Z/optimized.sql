CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_4.RETAIL.SP_CLONE_DB(
    source_db   STRING,
    clone_base  STRING,
    n_clones    NUMBER
)
RETURNS STRING
LANGUAGE SQL
AS
$$
/*
    Optimizations / improvements:
    - Added explicit parameter list and fully qualified procedure name.
    - Validated inputs and raised clear errors for invalid arguments.
    - Enforced maximum clone count to protect from accidental abuse.
    - Normalized clone names and used TO_VARCHAR instead of ::STRING for clarity.
    - Added IF NOT EXISTS guard logic via dynamic SQL pattern (commented example) for optional use.
*/
DECLARE
    i           NUMBER        DEFAULT 1;
    clone_name  STRING;
    v_message   STRING;
BEGIN
    -- Basic input validation to fail fast and avoid unnecessary work
    IF source_db IS NULL OR TRIM(source_db) = '' THEN
        RETURN 'ERROR: source_db must be a non-empty string.';
    END IF;

    IF clone_base IS NULL OR TRIM(clone_base) = '' THEN
        RETURN 'ERROR: clone_base must be a non-empty string.';
    END IF;

    IF n_clones IS NULL OR n_clones <= 0 THEN
        RETURN 'ERROR: n_clones must be a positive integer.';
    END IF;

    -- Optional safety cap to avoid runaway cloning (adjust as needed)
    IF n_clones > 1000 THEN
        RETURN 'ERROR: n_clones exceeds the safety limit of 1000.';
    END IF;

    -- Normalize database and base names to avoid trailing spaces
    LET v_source_db  STRING := TRIM(source_db);
    LET v_clone_base STRING := TRIM(clone_base);

    WHILE (i <= n_clones) DO
        clone_name := v_clone_base || '_' || TO_VARCHAR(i);

        /*
        -- Example pattern if you want an IF NOT EXISTS behavior:
        -- EXECUTE IMMEDIATE
        --     'CREATE DATABASE IF NOT EXISTS ' || IDENTIFIER(clone_name) ||
        --     ' CLONE ' || IDENTIFIER(v_source_db);
        */

        -- Use IDENTIFIER() to safely handle special characters / quoting in names
        EXECUTE IMMEDIATE
            'CREATE OR REPLACE DATABASE ' || IDENTIFIER(clone_name) ||
            ' CLONE ' || IDENTIFIER(v_source_db);

        i := i + 1;
    END WHILE;

    v_message := 'Created ' || n_clones || ' clones of ' || v_source_db
                 || ' named ' || v_clone_base || '_1 .. ' || v_clone_base || '_' || n_clones;

    RETURN v_message;
END;
$$;
