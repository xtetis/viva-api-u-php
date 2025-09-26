CREATE TABLE api.request_log (
  request_log_key SERIAL,
  method_name VARCHAR,
  request VARCHAR,
  run_result INTEGER,
  run_result_str VARCHAR,
  run_response VARCHAR,
  creation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT clock_timestamp() NOT NULL,
  CONSTRAINT request_log_pkey PRIMARY KEY(request_log_key)
) ;

COMMENT ON COLUMN api.request_log.request_log_key
IS 'Первичный ключ';

COMMENT ON COLUMN api.request_log.method_name
IS 'Имя метода';

COMMENT ON COLUMN api.request_log.request
IS 'Полученный запрос';

COMMENT ON COLUMN api.request_log.run_result
IS 'Результат запроса';

COMMENT ON COLUMN api.request_log.run_result_str
IS 'Результат запроса STR';

COMMENT ON COLUMN api.request_log.run_response
IS 'Выходной JSON';

COMMENT ON COLUMN api.request_log.creation_date
IS 'Дата создания записи';







CREATE TABLE api.logs (
  log_key SERIAL,
  message_level VARCHAR NOT NULL,
  message TEXT NOT NULL,
  function_name VARCHAR,
  context JSONB,
  error_code VARCHAR,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp(),
  CONSTRAINT logs_pkey PRIMARY KEY(log_key),
  CONSTRAINT logs_level_check CHECK ((message_level)::text = ANY (ARRAY[('ERROR'::character varying)::text, ('WARNING'::character varying)::text, ('INFO'::character varying)::text]))
) ;


