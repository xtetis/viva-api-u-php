


DROP TABLE IF EXISTS  api.dic_param CASCADE;
DROP TABLE IF EXISTS  api.external_connect CASCADE;
DROP TABLE IF EXISTS  api.logs CASCADE;
DROP TABLE IF EXISTS  api.method_request_func_type CASCADE;
DROP TABLE IF EXISTS  api.methods CASCADE;
DROP TABLE IF EXISTS  api.dic_param_values CASCADE;
DROP TABLE IF EXISTS  api.external_connect_params CASCADE;
DROP TABLE IF EXISTS  api.request_log CASCADE;
DROP TABLE IF EXISTS  api.method_example CASCADE;
DROP TABLE IF EXISTS  api.method_request_func CASCADE;
DROP TABLE IF EXISTS  api.method_setting CASCADE;



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