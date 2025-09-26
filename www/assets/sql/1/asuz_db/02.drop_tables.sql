


DROP TABLE IF EXISTS  api.request_log CASCADE;
DROP TABLE IF EXISTS  api.logs CASCADE;



DO $$
DECLARE
    seq_name TEXT;
BEGIN
    FOR seq_name IN (SELECT c.relname
                     FROM pg_class c
                     JOIN pg_namespace n ON n.oid = c.relnamespace
                     WHERE c.relkind = 'S' AND n.nspname = 'api')
    LOOP
        EXECUTE 'DROP SEQUENCE IF EXISTS ' || quote_ident(seq_name) || ' CASCADE;';
    END LOOP;
END $$;