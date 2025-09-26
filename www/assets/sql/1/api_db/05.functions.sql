-- DROP FUNCTION api.add_log(in varchar, in text, in varchar, in jsonb, in varchar, out int4, out text);

CREATE OR REPLACE FUNCTION api.add_log(_message_level character varying, _message text, _function_name character varying, _context jsonb DEFAULT NULL::jsonb, _error_code character varying DEFAULT NULL::character varying, OUT result integer, OUT result_str text)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
/*
  Функция api.add_log_entry добавляет запись в таблицу api.logs.
  На входе принимает параметры:
  - _message_level: уровень сообщения (ERROR, WARNING, INFO)
  - _message: текст сообщения
  - _function_name: имя функции, создавшей запись
  - _context: дополнительный контекст в формате JSONB (может быть NULL)
  - _error_code: код ошибки (по умолчанию NULL)
  Возвращает:
  - result: 1 (успех) или -1 (ошибка)
  - result_str: сообщение об успехе или текст ошибки
*/
BEGIN
    -- Проверка допустимости _message_level
    IF _message_level NOT IN ('ERROR', 'WARNING', 'INFO') THEN
        result := -1;
        result_str := 'Invalid message_level. Must be ERROR, WARNING, or INFO';
        RETURN;
    END IF;

    -- Проверка, что _message не пустой
    IF _message IS NULL OR TRIM(_message) = '' THEN
        result := -1;
        result_str := 'Message cannot be NULL or empty';
        RETURN;
    END IF;

    -- Вставка записи в таблицу logs
    INSERT INTO api.logs (
        message_level,
        message,
        function_name,
        context,
        error_code,
        created_at
    )
    VALUES (
        _message_level,
        _message,
        _function_name,
        _context,
        _error_code,
        clock_timestamp()
    );

    -- Успешное выполнение
    result := 1;
    result_str := 'Log entry created successfully';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка ошибок
    result := -1;
    result_str := SQLERRM;
    RETURN;
END;
$function$
;

-- DROP FUNCTION api.check_db_params(out int4, out varchar);

CREATE OR REPLACE FUNCTION api.check_db_params(OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
	v__rec__param RECORD;
	v__count INTEGER;
	v__required_params VARCHAR[];
	v__param_name VARCHAR;
	v__rec RECORD;
BEGIN
	v__required_params = '{}'::VARCHAR[];
	v__required_params = ARRAY_APPEND(v__required_params,'api_title_short');
	v__required_params = ARRAY_APPEND(v__required_params,'show_debug_info');
	v__required_params = ARRAY_APPEND(v__required_params,'add_in_debug_info_db_connect_data');
	v__required_params = ARRAY_APPEND(v__required_params,'log_service_request_body');
	v__required_params = ARRAY_APPEND(v__required_params,'log_service_post');
	v__required_params = ARRAY_APPEND(v__required_params,'enable_hmac');
	v__required_params = ARRAY_APPEND(v__required_params,'api_secret');
	v__required_params = ARRAY_APPEND(v__required_params,'show_log_fields');


	FOREACH v__param_name IN ARRAY v__required_params LOOP
		SELECT 
			*
		FROM
			api.get_param(v__param_name)
		INTO
			v__rec__param;
	
		IF v__rec__param.result < 0 THEN
			result = -1;
			result_str = v__rec__param.result_str;
			RETURN;
		END IF;

		v__rec__param.result_str = COALESCE(v__rec__param.result_str,'');
	
		IF LENGTH(v__rec__param.result_str) < 1 THEN
			result = -1;
			result_str = 'Не заполнен параметр '||v__param_name;
			RETURN;
		END IF;
	END LOOP;



	SELECT 
		COUNT(*)
	FROM 
		api.methods m
	INNER JOIN
		api.method_setting ms ON
			m.method_key = ms.method_key
			AND
			ms.db_type = db_type()
			AND
			ms.active = 1
	INTO
		v__count;

	IF v__count < 1 THEN
		result = -1;
		result_str = 'Не заполнены методы в api.methods или они не включены в api.method_setting';
		RETURN;
	END IF;


	FOR v__rec IN 
		SELECT 
			m.method_key
		FROM 
			api.methods m
		INNER JOIN
			api.method_setting ms ON
				m.method_key = ms.method_key
				AND
				ms.db_type = db_type()
				AND
				ms.active = 1
	LOOP
		SELECT 
			count(*)
		FROM api.method_example e
		WHERE
			e.method_key = v__rec.method_key
		INTO
			v__count;

		IF v__count < 1 THEN
			result = -1;
			result_str = 'Для метода #'||
				v__rec.method_key ||
				' не заполнены примеры в api.method_example';
			RETURN;
		END IF;
	END LOOP;
	

	result_str = 'Проверка пройдена';
	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в check_db_params:'||SQLERRM,
        'check_db_params',
        jsonb_build_object(
			'sql_error', SQLERRM
		),
        v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_external_connect_json(in int4, out int4, out varchar);

CREATE OR REPLACE FUNCTION api.get_external_connect_json(_external_connect_key integer, OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
	v__count INTEGER;
BEGIN

	_external_connect_key = COALESCE(_external_connect_key,0);

	SELECT 
		COUNT(*)
	FROM 
		api.external_connect t
	INNER JOIN
		api.external_connect_params p ON
			p.external_connect_key = t.external_connect_key 
			AND
			p.inner_db_type = db_type()
	WHERE
		t.external_connect_key = _external_connect_key
	INTO
		v__count;

	IF v__count < 1 THEN
		result = -1;
		result_str = 'Не заполнены днные для подключения к БД #' ||
			_external_connect_key ||
			' в api.external_connect + api.external_connect_params';
		RETURN;
	END IF;

	
	
	SELECT jsonb_agg(tmp)::VARCHAR
	FROM
		(
			SELECT 
				*
			FROM 
				api.external_connect t
			INNER JOIN
				api.external_connect_params p ON
					p.external_connect_key = t.external_connect_key 
					AND
					p.inner_db_type = db_type()
			WHERE
				t.external_connect_key = _external_connect_key
		) tmp
	INTO
		result_str;
	

	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в get_external_connect_json:'||SQLERRM,
        'get_external_connect_json',
        jsonb_build_object(
			'sql_error', SQLERRM
		),
        v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_method_examples_json(in int4, out int4, out varchar);

CREATE OR REPLACE FUNCTION api.get_method_examples_json(_method_key integer, OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
	v__count INTEGER;
BEGIN
	_method_key = COALESCE(_method_key,0);

	SELECT 
		COUNT(*)
	FROM 
		api.method_example e
	WHERE
		e.method_key = _method_key
		AND
		COALESCE(e.active,0) = 1
	INTO
		v__count;

	IF v__count < 1 THEN
		result = -1;
		result_str = 'Не заполнены примеры метода #' ||
			_method_key' в api.method_example или они не включены';
		RETURN;
	END IF;

	
	
	SELECT jsonb_agg(tmp)::VARCHAR
	FROM
		(
			SELECT 
				*
			FROM 
				api.method_example e
			WHERE
				e.method_key = _method_key
				AND
				COALESCE(e.active,0) = 1
		) tmp
	INTO
		result_str;
	

	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в get_method_examples_json:'||SQLERRM,
        'get_method_examples_json',
        jsonb_build_object(
			'sql_error', SQLERRM
		),
        v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_method_list_json(out int4, out varchar);

CREATE OR REPLACE FUNCTION api.get_method_list_json(OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
	v__count INTEGER;
BEGIN


	SELECT 
		COUNT(*)
	FROM 
		api.methods m
	INNER JOIN
		api.method_setting ms ON
			m.method_key = ms.method_key
			AND
			ms.db_type = db_type()
			AND
			ms.active = 1
	INTO
		v__count;

	IF v__count < 1 THEN
		result = -1;
		result_str = 'Не заполнены методы в api.methods или они не включены в api.method_setting';
		RETURN;
	END IF;
	
	SELECT jsonb_agg(tmp)::VARCHAR
	FROM
		(
			SELECT 
				m.*
			FROM 
				api.methods m
			INNER JOIN
				api.method_setting ms ON
					m.method_key = ms.method_key
					AND
					ms.db_type = db_type()
					AND
					ms.active = 1
		) tmp
	INTO
		result_str;
	

	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в get_method_list_json:'||SQLERRM,
        'get_method_list_json',
        jsonb_build_object(
			'sql_error', SQLERRM
		),
        v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_method_request_func_list_json(in int4, out int4, out varchar);

CREATE OR REPLACE FUNCTION api.get_method_request_func_list_json(_method_key integer, OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
	v__count INTEGER;
BEGIN

	_method_key = COALESCE(_method_key,0);

	SELECT 
		COUNT(*)
	FROM 
		api.method_request_func f
	INNER JOIN
		api.method_request_func_type t ON
		t.method_request_func_type_key = f.method_request_func_type_key
	WHERE
		method_key = _method_key
	INTO
		v__count;

	IF v__count = 0 THEN
		result = 0;
		result_str = 'Для метода не предусмотрено выполнение методов в БД';
		RETURN;
	END IF;
	
	SELECT jsonb_agg(tmp)::VARCHAR
	FROM
		(
			SELECT 
				f.*,
				t.type_name,
				t.title as type_title
			FROM 
				api.method_request_func f
			INNER JOIN
				api.method_request_func_type t ON
				t.method_request_func_type_key = f.method_request_func_type_key
			WHERE
				method_key = _method_key
		) tmp
	INTO
		result_str;
	

	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в get_method_request_func_list_json:'||SQLERRM,
        'get_method_request_func_list_json',
        jsonb_build_object(
			'sql_error', SQLERRM
		),
        v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_param(in varchar, out int4, out varchar);

CREATE OR REPLACE FUNCTION api.get_param(_param_name character varying, OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
BEGIN
	IF COALESCE(_param_name, '') = '' THEN
    	RAISE EXCEPTION 'Не указано имя параметра';
    END IF;

    PERFORM p.*
    FROM api.dic_param  AS p
    WHERE p.param_name = _param_name;
    IF not FOUND THEN
    	raise exception 'Параметр "%" отсутствует в справочнике "api.dic_param"'
        	, _param_name;
    END IF;

	SELECT pv.param_value
    FROM api.dic_param  AS p
    JOIN api.dic_param_values as pv
    	ON pv.param_key = p.param_key
    WHERE p.param_name = _param_name
    	AND p.active = 1
    	AND COALESCE(pv.param_category, '') =
        	COALESCE(db_type(), pv.param_category, '')
        AND pv.active = 1
    ORDER BY pv.param_value_key DESC
    LIMIT 1
    INTO result_str;

	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в get_param',
        'get_param',
        jsonb_build_object(
			'sql_error', SQLERRM,
			'_param_name',_param_name
		),
		v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_request_log_list_json(out int4, out varchar);

CREATE OR REPLACE FUNCTION api.get_request_log_list_json(OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	v__context VARCHAR;
	v__count INTEGER;
BEGIN


	
	SELECT jsonb_agg(tmp)::VARCHAR
	FROM
		(
			SELECT 
				t.*
			FROM 
				api.request_log t
			ORDER BY
				t.create_date DESC
			LIMIT 
				20
		) tmp
	INTO
		result_str;
	

	result = 1;

	RETURN;
EXCEPTION WHEN OTHERS THEN
	result = -1;
	result_str = SQLERRM;

    GET STACKED DIAGNOSTICS
        v__context = PG_EXCEPTION_CONTEXT;

    PERFORM api.add_log(
        'ERROR',
        'Неожиданная ошибка в get_request_log_list_json:'||SQLERRM,
        'get_request_log_list_json',
        jsonb_build_object(
			'sql_error', SQLERRM
		),
        v__context
    );
END;
$function$
;

-- DROP FUNCTION api.get_version(out int4);

CREATE OR REPLACE FUNCTION api.get_version(OUT result integer)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
	--
BEGIN
	result = 1;
	RETURN;
END;
$function$
;

-- DROP FUNCTION api.run_request_method(in varchar, in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.run_request_method(_method character varying, _request character varying, _run_method character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v__context varchar;
    v__sql varchar;
    v__rec__run_method record;
BEGIN
    _request = COALESCE(_request, '');
    _method = COALESCE(_method, '');
    _run_method = COALESCE(_run_method, '');

    IF _method = '' THEN
        result = -1;
        result_str = 'method is empty';
        RETURN;
    END IF;

    IF _request = '' THEN
        result = -1;
        result_str = 'request is empty';
        RETURN;
    END IF;

    IF _run_method = '' THEN
        result = -1;
        result_str = '_run_method is empty';
        RETURN;
    END IF;

    -- Формируем динамический SQL скрипт, который приримает _request как 
    -- входной параметр, а _validate_run_method - это имя метода 
    -- валидации
    v__sql = 'SELECT * FROM ' || _run_method || '($1, $2)';
    BEGIN
        EXECUTE v__sql USING _method, _request INTO v__rec__run_method;
    EXCEPTION
        WHEN OTHERS THEN
            result = -1;
            result_str = 'Ошибка при валидации запроса: ' || SQLERRM;
            GET STACKED DIAGNOSTICS v__context = PG_EXCEPTION_CONTEXT;
            PERFORM
                api.add_log(
                    'ERROR', 
                    'Ошибка в validate_run_method', 
                    'validate_run_method', 
                    jsonb_build_object(
						'sql_error', SQLERRM,
						'v__sql', v__sql
					), 
					v__context
                );
		RETURN;
    END;

    IF v__rec__run_method.result < 0 THEN
        result = v__rec__run_method.result;
        result_str = v__rec__run_method.result_str;
        RETURN;
    END IF;

    result_str = 'OK';
    result = 1;
	response = v__rec__run_method.response;
    RETURN;
EXCEPTION
    WHEN OTHERS THEN
        result = -1;
        result_str = SQLERRM;
        GET STACKED DIAGNOSTICS v__context = PG_EXCEPTION_CONTEXT;
        PERFORM
            api.add_log('ERROR', 'Неожиданная ошибка в validate_run_method', 'validate_run_method', jsonb_build_object('sql_error', SQLERRM), v__context);
END;

$function$
;

-- DROP FUNCTION api.set_request_log(in varchar, out int4, out varchar);

CREATE OR REPLACE FUNCTION api.set_request_log(_json character varying, OUT result integer, OUT result_str character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_json jsonb;
    v_request_log_key int4;
    v_method_key int4;
    v_request varchar;
    v_run_result int4;
    v_run_result_str varchar;
    v_service_request_body varchar;
    v_service_post varchar;
    v_service_request_url varchar;
    v_method_name varchar;
    v_context varchar;
	v__log_service_request_body INTEGER;
	v__log_service_post INTEGER;
	v__rec__method_setting RECORD;

	v__log_method_request INTEGER;
	v__log_method_response INTEGER;
	v__rec__param RECORD;
BEGIN

	/*
    PERFORM api.add_log(
		'INFO', 
		'zzzzzzzzz', 
		'set_request_log', 
        jsonb_build_object(
			'input_json', _json
		)
	);
	*/

    -- Проверка валидности JSON
    BEGIN
        v_json := _json::jsonb;
    EXCEPTION
        WHEN invalid_text_representation THEN
            result := -1;
            result_str := 'Invalid JSON format';
            PERFORM api.add_log(
				'ERROR', 
				'Invalid JSON in set_request_log', 
				'set_request_log', 
                jsonb_build_object(
					'sql_error', SQLERRM, 
					'input_json', _json
				), 
				PG_EXCEPTION_CONTEXT);
            RETURN;
    END;

    -- Извлечение значений из JSON
    v_request_log_key := (v_json->>'request_log_key')::int4;
    v_method_key := (v_json->>'method_key')::int4;
    v_request := v_json->>'request';
    v_run_result := (v_json->>'run_result')::int4;
    v_run_result_str := v_json->>'run_result_str';
    v_service_request_body := v_json->>'service_request_body';
    v_service_post := v_json->>'service_post';
    v_service_request_url := v_json->>'service_request_url';
    v_method_name := v_json->>'method_name';

    -- Проверка типов данных
    BEGIN
        IF v_json->>'request_log_key' IS NOT NULL AND v_request_log_key IS NULL THEN
            RAISE EXCEPTION 'Invalid request_log_key format';
        END IF;
        IF v_json->>'method_key' IS NOT NULL AND v_method_key IS NULL THEN
            RAISE EXCEPTION 'Invalid method_key format';
        END IF;
        IF v_json->>'run_result' IS NOT NULL AND v_run_result IS NULL THEN
            RAISE EXCEPTION 'Invalid run_result format';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            result := -1;
            result_str := SQLERRM;
            PERFORM api.add_log('ERROR', 'Invalid data type in set_request_log', 'set_request_log', 
                jsonb_build_object('sql_error', SQLERRM, 'input_json', _json), PG_EXCEPTION_CONTEXT);
            RETURN;
    END;

	SELECT
		*
	FROM 
		api.get_param('log_service_request_body')
	INTO
		v__rec__param;

	IF v__rec__param.result < 0 THEN
		result = -1;
		result_str = v__rec__param.result_str;
		RETURN;
	END IF;

	v__log_service_request_body = v__rec__param.result_str::INTEGER;



	SELECT
		*
	FROM 
		api.get_param('log_service_post')
	INTO
		v__rec__param;

	IF v__rec__param.result < 0 THEN
		result = -1;
		result_str = v__rec__param.result_str;
		RETURN;
	END IF;

	v__log_service_post = v__rec__param.result_str::INTEGER;



	IF v__log_service_request_body != 1 THEN
		v_service_request_body = NULL;
	END IF;

	IF v__log_service_post != 1 THEN
		v_service_post = NULL;
	END IF;

	v__log_method_request = 0;
	v__log_method_response = 0;
	IF COALESCE(v_method_key,0) > 0 THEN
		SELECT *
		FROM 
			api.method_setting t
		WHERE
			t.method_key = v_method_key
			AND
			t.db_type = db_type()
		INTO
			v__rec__method_setting;

		
		IF FOUND THEN 
			IF v__rec__method_setting.log_method_request > 0 THEN
				v__log_method_request = 1;
			END IF;
			IF v__rec__method_setting.log_method_response > 0 THEN
				v__log_method_response = 1;
			END IF;
		END IF;
	END IF;

	IF v_request_log_key IS NOT NULL THEN
		SELECT *
		FROM 
			api.method_setting t
		WHERE
			t.method_key IN 
			(
				SELECT method_key
				FROM api.request_log
				WHERE request_log_key = v_request_log_key
			)
			AND
			t.db_type = db_type()
		INTO
			v__rec__method_setting;

		
		IF FOUND THEN 
			IF v__rec__method_setting.log_method_request > 0 THEN
				v__log_method_request = 1;
			END IF;
			IF v__rec__method_setting.log_method_response > 0 THEN
				v__log_method_response = 1;
			END IF;
		END IF;
	END IF;

	IF v__log_method_request != 1 THEN
		v_request = NULL;
	END IF;

	IF v__log_method_response != 1 THEN
		v_run_result_str = NULL;
	END IF;

    -- Если request_log_key указан - обновляем существующую запись
    IF v_request_log_key IS NOT NULL THEN
        UPDATE api.request_log
        SET 
            method_key = COALESCE(v_method_key, method_key),
            request = COALESCE(v_request, request),
            run_result = COALESCE(v_run_result, run_result),
            run_result_str = COALESCE(v_run_result_str, run_result_str),
            service_request_body = COALESCE(v_service_request_body, service_request_body),
            service_post = COALESCE(v_service_post, service_post),
            service_request_url = COALESCE(v_service_request_url, service_request_url),
            method_name = COALESCE(v_method_name, method_name)
        WHERE request_log_key = v_request_log_key
        RETURNING request_log_key INTO result;

        IF NOT FOUND THEN
            result := -1;
            result_str := 'Record with request_log_key ' || v_request_log_key || ' not found';
            PERFORM api.add_log('ERROR', 'Record not found in set_request_log', 'set_request_log', 
                jsonb_build_object('sql_error', 'Record not found', 'request_log_key', v_request_log_key), PG_EXCEPTION_CONTEXT);
            RETURN;
        END IF;

        result_str := 'OK';
        RETURN;
    END IF;

    -- Если request_log_key не указан - вставляем новую запись
    INSERT INTO api.request_log (
        method_key,
        request,
        run_result,
        run_result_str,
        service_request_body,
        service_post,
        service_request_url,
        method_name
    )
    VALUES (
        v_method_key,
        v_request,
        v_run_result,
        v_run_result_str,
        v_service_request_body,
        v_service_post,
        v_service_request_url,
        v_method_name
    )
    RETURNING request_log_key INTO result;

    result_str := 'OK';
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        result := -1;
        result_str := SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log('ERROR', 'Unexpected error in set_request_log', 'set_request_log', 
            jsonb_build_object('sql_error', SQLERRM, 'input_json', _json), v_context);
        RETURN;
END;
$function$
;

-- DROP FUNCTION api.temp_run_method(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.temp_run_method(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v__context varchar;
BEGIN
   

    result_str = 'OK';
    result = 1;
	response = '{}';
    RETURN;
EXCEPTION
    WHEN OTHERS THEN
        result = -1;
        result_str = SQLERRM;
        GET STACKED DIAGNOSTICS v__context = PG_EXCEPTION_CONTEXT;
        PERFORM
            api.add_log('ERROR', 
'Неожиданная ошибка в temp_run_method', 
'temp_run_method', 
jsonb_build_object('sql_error', SQLERRM), v__context);
END;

$function$
;