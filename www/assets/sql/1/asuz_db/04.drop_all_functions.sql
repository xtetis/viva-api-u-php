DO $$
DECLARE
    func_record RECORD;
    schema_name TEXT := 'api';
BEGIN
    FOR func_record IN
        SELECT
            p.proname AS function_name,
            pg_catalog.pg_get_function_identity_arguments(p.oid) AS function_args
        FROM
            pg_catalog.pg_namespace n
        JOIN
            pg_catalog.pg_proc p ON p.pronamespace = n.oid
        WHERE
            n.nspname = schema_name
            AND p.prokind = 'f' -- 'f' for functions
    LOOP
        EXECUTE FORMAT('DROP FUNCTION %I.%I(%s) CASCADE;',
                       schema_name,
                       func_record.function_name,
                       func_record.function_args);
    END LOOP;
END $$;