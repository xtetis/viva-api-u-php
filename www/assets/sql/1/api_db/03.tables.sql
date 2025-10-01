




CREATE TABLE api.dic_param (
	param_key serial4 NOT NULL,
	param_name varchar NULL,
	param_descr varchar NULL,
	active int4 DEFAULT 1 NULL,
	created_on timestamp(6) DEFAULT now() NULL,
	CONSTRAINT dic_param_pkey PRIMARY KEY (param_key)
);


-- api.external_connect определение

-- Drop table



CREATE TABLE api.external_connect (
	external_connect_key serial4 NOT NULL, -- Первичный ключ
	connect_name varchar NOT NULL, -- Имя коннекта
	CONSTRAINT external_connect_pk PRIMARY KEY (external_connect_key),
	CONSTRAINT external_connect_unique UNIQUE (connect_name)
);
COMMENT ON TABLE api.external_connect IS 'Список коннектов';

-- Column comments

COMMENT ON COLUMN api.external_connect.external_connect_key IS 'Первичный ключ';
COMMENT ON COLUMN api.external_connect.connect_name IS 'Имя коннекта';


-- api.logs определение

-- Drop table



CREATE TABLE api.logs (
	log_key serial4 NOT NULL,
	message_level varchar NOT NULL,
	message text NOT NULL,
	function_name varchar NULL,
	context jsonb NULL,
	error_code varchar NULL,
	created_at timestamptz DEFAULT clock_timestamp() NULL,
	CONSTRAINT logs_level_check CHECK (((message_level)::text = ANY (ARRAY[('ERROR'::character varying)::text, ('WARNING'::character varying)::text, ('INFO'::character varying)::text]))),
	CONSTRAINT logs_pkey PRIMARY KEY (log_key)
);


-- api.method_request_func_type определение

-- Drop table

CREATE TABLE api.method_request_func_type (
	method_request_func_type_key serial4 NOT NULL, -- Первичный ключ
	type_name varchar NOT NULL, -- Имя типа метода (латиницей)
	title varchar NOT NULL, -- Описание типа метода
	created_on timestamp DEFAULT now() NULL, -- Дата время создания записи
	CONSTRAINT method_request_func_type_pk PRIMARY KEY (method_request_func_type_key),
	CONSTRAINT method_request_func_type_unique UNIQUE (type_name)
);

-- Column comments

COMMENT ON COLUMN api.method_request_func_type.method_request_func_type_key IS 'Первичный ключ';
COMMENT ON COLUMN api.method_request_func_type.type_name IS 'Имя типа метода (латиницей)';
COMMENT ON COLUMN api.method_request_func_type.title IS 'Описание типа метода';
COMMENT ON COLUMN api.method_request_func_type.created_on IS 'Дата время создания записи';


-- api.methods определение

-- Drop table


CREATE TABLE api.methods (
	method_key serial4 NOT NULL, -- Перыичный ключ
	method_name varchar NOT NULL, -- Имя метода
	title varchar NOT NULL, -- Краткое описание
	created_on timestamp DEFAULT clock_timestamp() NULL, -- Дата/время создания записи
	description varchar NOT NULL, -- Описание метода (пару предложений)
	html_description varchar NOT NULL, -- Описание метода HTML (для вывода в API)
	request_json_schema varchar NULL, -- JSON схема для проверки запроса
	require_request_body int4 DEFAULT 1 NOT NULL, -- Требует тело запроса (если 0 - то подразумевает GET запрос)
	test_form__show_file_upload_input int4 DEFAULT 0 NULL, -- Показывать на тестовой форме поле ффода файла (0/1)
	request_body_must_be_json int4 DEFAULT 1 NULL, -- Тело запроса должно быть валидным JSON
	response_type varchar NULL, -- Формат ответа (eis|NULL)
	CONSTRAINT check_method_name CHECK (((method_name)::text ~ '^[a-z0-9_]+$'::text)),
	CONSTRAINT check_response_type CHECK (((response_type IS NULL) OR ((response_type)::text = 'eis'::text))),
	CONSTRAINT method_pkey PRIMARY KEY (method_key)
);

-- Column comments

COMMENT ON COLUMN api.methods.method_key IS 'Перыичный ключ';
COMMENT ON COLUMN api.methods.method_name IS 'Имя метода';
COMMENT ON COLUMN api.methods.title IS 'Краткое описание';
COMMENT ON COLUMN api.methods.created_on IS 'Дата/время создания записи';
COMMENT ON COLUMN api.methods.description IS 'Описание метода (пару предложений)';
COMMENT ON COLUMN api.methods.html_description IS 'Описание метода HTML (для вывода в API)';
COMMENT ON COLUMN api.methods.request_json_schema IS 'JSON схема для проверки запроса';
COMMENT ON COLUMN api.methods.require_request_body IS 'Требует тело запроса (если 0 - то подразумевает GET запрос)';
COMMENT ON COLUMN api.methods.test_form__show_file_upload_input IS 'Показывать на тестовой форме поле ффода файла (0/1)';
COMMENT ON COLUMN api.methods.request_body_must_be_json IS 'Тело запроса должно быть валидным JSON';
COMMENT ON COLUMN api.methods.response_type IS 'Формат ответа (eis|NULL)';


-- api.dic_param_values определение

-- Drop table


CREATE TABLE api.dic_param_values (
	param_value_key serial4 NOT NULL,
	param_key int4 NULL,
	param_value varchar NULL,
	param_category varchar NULL,
	active int4 DEFAULT 1 NULL,
	created_on timestamp(6) DEFAULT now() NULL,
	descr varchar NULL,
	CONSTRAINT check_param_category CHECK (((param_category)::text = ANY ((ARRAY['DEV'::character varying, 'WORK'::character varying, 'PREDRELEASE'::character varying])::text[]))),
	CONSTRAINT dic_param_values_pkey PRIMARY KEY (param_value_key),
	CONSTRAINT dic_param_values_dic_param_fk FOREIGN KEY (param_key) REFERENCES api.dic_param(param_key) ON DELETE CASCADE ON UPDATE CASCADE
);


-- api.external_connect_params определение

-- Drop table



CREATE TABLE api.external_connect_params (
	external_connect_param_key serial4 NOT NULL, -- Первичный ключ
	created_on timestamp DEFAULT now() NULL, -- Дата время создания записи
	db_host varchar NOT NULL, -- Хост подключения
	db_port varchar NOT NULL, -- Порт  подключения
	db_username varchar NOT NULL, -- Пользователь для  подключения
	db_password varchar NOT NULL, -- Пароль для подключения
	db_database varchar NOT NULL, -- Имя базы
	inner_db_type varchar NOT NULL, -- Тип подключения (DEV|WORK)
	external_connect_key int4 NULL, -- К какому коннекту принадлежит эти настройки коннекта
	CONSTRAINT external_base_pk PRIMARY KEY (external_connect_param_key),
	CONSTRAINT external_base_unique UNIQUE (db_database, db_host, db_port),
	CONSTRAINT external_base_unique_1 UNIQUE (db_database, inner_db_type),
	CONSTRAINT external_connect_params_unique UNIQUE (external_connect_key, inner_db_type),
	CONSTRAINT external_connect_params_external_connect_fk FOREIGN KEY (external_connect_key) REFERENCES api.external_connect(external_connect_key) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Column comments

COMMENT ON COLUMN api.external_connect_params.external_connect_param_key IS 'Первичный ключ';
COMMENT ON COLUMN api.external_connect_params.created_on IS 'Дата время создания записи';
COMMENT ON COLUMN api.external_connect_params.db_host IS 'Хост подключения';
COMMENT ON COLUMN api.external_connect_params.db_port IS 'Порт  подключения';
COMMENT ON COLUMN api.external_connect_params.db_username IS 'Пользователь для  подключения';
COMMENT ON COLUMN api.external_connect_params.db_password IS 'Пароль для подключения';
COMMENT ON COLUMN api.external_connect_params.db_database IS 'Имя базы';
COMMENT ON COLUMN api.external_connect_params.inner_db_type IS 'Тип подключения (DEV|WORK)';
COMMENT ON COLUMN api.external_connect_params.external_connect_key IS 'К какому коннекту принадлежит эти настройки коннекта';


-- api.method_example определение

-- Drop table



CREATE TABLE api.method_example (
	method_example_key serial4 NOT NULL, -- Первичный ключ
	method_key int4 NOT NULL, -- Ссылка на метод
	created_on timestamp DEFAULT now() NULL, -- Дата время создания  записи
	json_example varchar NOT NULL, -- Тело примера
	example_name varchar DEFAULT 'main'::character varying NOT NULL, -- Название примера
	active int4 DEFAULT 1 NOT NULL, -- Активность записи
	CONSTRAINT check_active CHECK ((active = ANY (ARRAY[0, 1]))),
	CONSTRAINT check_example_name_chars CHECK (((example_name)::text ~ '^[a-zA-Z0-9_]+$'::text)),
	CONSTRAINT check_example_name_length CHECK ((length((example_name)::text) > 0)),
	CONSTRAINT method_example_pk PRIMARY KEY (method_example_key),
	CONSTRAINT method_example_unique UNIQUE (example_name, method_key),
	CONSTRAINT method_example_methods_fk FOREIGN KEY (method_key) REFERENCES api.methods(method_key) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX method_example_method_key_idx ON api.method_example USING btree (method_key);

-- Column comments

COMMENT ON COLUMN api.method_example.method_example_key IS 'Первичный ключ';
COMMENT ON COLUMN api.method_example.method_key IS 'Ссылка на метод';
COMMENT ON COLUMN api.method_example.created_on IS 'Дата время создания  записи';
COMMENT ON COLUMN api.method_example.json_example IS 'Тело примера';
COMMENT ON COLUMN api.method_example.example_name IS 'Название примера';
COMMENT ON COLUMN api.method_example.active IS 'Активность записи';


-- api.method_request_func определение

-- Drop table

CREATE TABLE api.method_request_func (
	method_request_func_key serial4 NOT NULL, -- Первичный ключ
	created_on timestamp DEFAULT now() NULL, -- Дата время создания записи
	method_request_func_name varchar NOT NULL, -- Имя метода
	method_request_func_type_key int4 NOT NULL, -- Тип функции (в какой момент она выполняется)
	external_connect_key int4 NULL, -- Ключ соединения или NULL (если в той же БД)
	method_key int4 NOT NULL, -- Ключ метода
	return_as_run_data int4 DEFAULT 1 NOT NULL, -- Возвращать результат в ноде run_data
	CONSTRAINT method_request_func_pk PRIMARY KEY (method_request_func_key),
	CONSTRAINT method_request_func_unique UNIQUE (method_key, method_request_func_type_key),
	CONSTRAINT method_request_func_external_connect_fk FOREIGN KEY (external_connect_key) REFERENCES api.external_connect(external_connect_key) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT method_request_func_method_request_func_type_fk FOREIGN KEY (method_request_func_type_key) REFERENCES api.method_request_func_type(method_request_func_type_key) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT method_request_func_methods_fk FOREIGN KEY (method_key) REFERENCES api.methods(method_key) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX method_request_func_external_base_key_idx ON api.method_request_func USING btree (external_connect_key);
CREATE INDEX method_request_func_method_key_idx ON api.method_request_func USING btree (method_key);
CREATE INDEX method_request_func_method_request_func_type_key_idx ON api.method_request_func USING btree (method_request_func_type_key);
COMMENT ON TABLE api.method_request_func IS 'Список функций, которые нужно выполнять по ходу работы метода

Все методы выполняются через api.run_request_method';

-- Column comments

COMMENT ON COLUMN api.method_request_func.method_request_func_key IS 'Первичный ключ';
COMMENT ON COLUMN api.method_request_func.created_on IS 'Дата время создания записи';
COMMENT ON COLUMN api.method_request_func.method_request_func_name IS 'Имя метода';
COMMENT ON COLUMN api.method_request_func.method_request_func_type_key IS 'Тип функции (в какой момент она выполняется)';
COMMENT ON COLUMN api.method_request_func.external_connect_key IS 'Ключ соединения или NULL (если в той же БД)';
COMMENT ON COLUMN api.method_request_func.method_key IS 'Ключ метода';
COMMENT ON COLUMN api.method_request_func.return_as_run_data IS 'Возвращать результат в ноде run_data';


-- api.method_setting определение

-- Drop table

CREATE TABLE api.method_setting (
	method_setting_key serial4 NOT NULL, -- Первичный ключ
	db_type varchar NOT NULL, -- Тип БД
	method_key int4 NOT NULL, -- Ключ метода
	active int4 DEFAULT 1 NOT NULL, -- Активность метода для типа БД
	log_method_request int4 DEFAULT 0 NOT NULL, -- Логировать тело запроса метода
	log_method_response int4 DEFAULT 0 NOT NULL, -- Логировать ответ метода
	emulate_response int4 DEFAULT 0 NULL, -- Эмулировать ответ API
	emulate_response_body varchar NULL, -- Эмелированное тело ответа
	CONSTRAINT check_active CHECK ((active = ANY (ARRAY[0, 1]))),
	CONSTRAINT check_db_type CHECK (((db_type)::text = ANY ((ARRAY['DEV'::character varying, 'WORK'::character varying, 'PREDRELEASE'::character varying])::text[]))),
	CONSTRAINT check_log_method_request CHECK ((log_method_request = ANY (ARRAY[0, 1]))),
	CONSTRAINT method_active_pk PRIMARY KEY (method_setting_key),
	CONSTRAINT method_active_unique UNIQUE (db_type, method_key),
	CONSTRAINT method_active_method_fk FOREIGN KEY (method_key) REFERENCES api.methods(method_key) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX method_setting_active_idx ON api.method_setting USING btree (active);
CREATE INDEX method_setting_db_type_idx ON api.method_setting USING btree (db_type);
CREATE INDEX method_setting_method_key_idx ON api.method_setting USING btree (method_key);

-- Column comments

COMMENT ON COLUMN api.method_setting.method_setting_key IS 'Первичный ключ';
COMMENT ON COLUMN api.method_setting.db_type IS 'Тип БД';
COMMENT ON COLUMN api.method_setting.method_key IS 'Ключ метода';
COMMENT ON COLUMN api.method_setting.active IS 'Активность метода для типа БД';
COMMENT ON COLUMN api.method_setting.log_method_request IS 'Логировать тело запроса метода';
COMMENT ON COLUMN api.method_setting.log_method_response IS 'Логировать ответ метода';
COMMENT ON COLUMN api.method_setting.emulate_response IS 'Эмулировать ответ API';
COMMENT ON COLUMN api.method_setting.emulate_response_body IS 'Эмелированное тело ответа';


-- api.request_log определение

-- Drop table


CREATE TABLE api.request_log (
	request_log_key serial4 NOT NULL, -- Первичный ключ
	create_date timestamp DEFAULT clock_timestamp() NULL, -- Дата время создания записи
	method_key int4 NULL, -- Ключ метода
	request varchar NULL, -- Тело запроса
	run_result int4 NULL, -- Результат запроса
	run_result_str varchar NULL, -- Результат запроса
	service_request_body varchar NULL, -- Тело запроса к сервису
	service_post varchar NULL, -- POST параметры в виде JSON
	service_request_url varchar NULL, -- Урл запроса к сервису
	method_name varchar NULL, -- Имя метода
	CONSTRAINT request_log_pk PRIMARY KEY (request_log_key),
	CONSTRAINT request_log_methods_fk FOREIGN KEY (method_key) REFERENCES api.methods(method_key) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE api.request_log IS 'Лог запросов методов';

-- Column comments

COMMENT ON COLUMN api.request_log.request_log_key IS 'Первичный ключ';
COMMENT ON COLUMN api.request_log.create_date IS 'Дата время создания записи';
COMMENT ON COLUMN api.request_log.method_key IS 'Ключ метода';
COMMENT ON COLUMN api.request_log.request IS 'Тело запроса';
COMMENT ON COLUMN api.request_log.run_result IS 'Результат запроса';
COMMENT ON COLUMN api.request_log.run_result_str IS 'Результат запроса';
COMMENT ON COLUMN api.request_log.service_request_body IS 'Тело запроса к сервису';
COMMENT ON COLUMN api.request_log.service_post IS 'POST параметры в виде JSON';
COMMENT ON COLUMN api.request_log.service_request_url IS 'Урл запроса к сервису';
COMMENT ON COLUMN api.request_log.method_name IS 'Имя метода';




CREATE TABLE api.service_request_log (
	service_request_log_key serial4 NOT NULL, -- Первичный ключ
	created_on timestamp DEFAULT clock_timestamp() NULL, -- Дата время создания записи
	request_url varchar NULL, -- Урл запроса
	request_body varchar NULL, -- Тело запроса
	get_params varchar NULL, -- GET параметры
	post_params varchar NULL, -- POST параметры
	CONSTRAINT service_log_pk PRIMARY KEY (service_request_log_key)
);
COMMENT ON TABLE api.service_request_log IS 'Список запросов к сервису (для отладки)';

-- Column comments

COMMENT ON COLUMN api.service_request_log.service_request_log_key IS 'Первичный ключ';
COMMENT ON COLUMN api.service_request_log.created_on IS 'Дата время создания записи';
COMMENT ON COLUMN api.service_request_log.request_url IS 'Урл запроса';
COMMENT ON COLUMN api.service_request_log.request_body IS 'Тело запроса';
COMMENT ON COLUMN api.service_request_log.get_params IS 'GET параметры';
COMMENT ON COLUMN api.service_request_log.post_params IS 'POST параметры';