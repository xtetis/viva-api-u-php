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

-- DROP FUNCTION api.parse_request_for_check_client_data(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.parse_request_for_check_client_data(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
/*<description>
	Метод проверки заявочных данных, принимающий JSON и возвращающий JSON
</description>
<history_list>
    <item><date_m>27.06.2024</date_m><task_n>35054374</task_n><author>Крупская И.Е.</author></item>
    <item><date_m>24.09.2025</date_m><task_n>Unknown</task_n><author>Updated for JSON processing</author></item>
    <item><date_m>26.09.2025</date_m><task_n>Unknown</task_n><author>Updated for NULL handling</author></item>
</history_list>*/
    v_json JSONB; -- Переменная для хранения входного JSON
    v_business_key VARCHAR;
    v_req_sum NUMERIC;
    v_req_term VARCHAR;
    v_lastname VARCHAR;
    v_firstname VARCHAR;
    v_patronimic VARCHAR;
    v_birthday DATE;
    v_phone_mobile VARCHAR;
    v_email VARCHAR;
    v_inn VARCHAR;
    v_gender VARCHAR;
    v_pass_serial VARCHAR;
    v_pass_number VARCHAR;
    v_pass_issuer VARCHAR;
    v_pass_issuer_code VARCHAR;
    v_pass_issue_date DATE;
    v_birthplace VARCHAR;
    v_reg_address VARCHAR;
    v_fact_address VARCHAR;
    v_family_status VARCHAR;
    v_emloyment_type VARCHAR;
    v_organization_type VARCHAR;
    v_company_occupation VARCHAR;
    v_position_type VARCHAR;
    v_last_work_term VARCHAR;
    v_monthly_income NUMERIC;
    v_is_black_list VARCHAR;
    v_is_active_debt VARCHAR;
    v_is_debt_holiday VARCHAR;
    v_borrower_key INTEGER;
    v_context VARCHAR; -- Для логирования контекста ошибки
BEGIN
    -- Инициализация выходных параметров
    result = 1;
    result_str = 'OK';
    response = '{}';

    -- Парсинг входного JSON
    BEGIN
        v_json = _request::JSONB;
    EXCEPTION WHEN OTHERS THEN
        result = -1;
        result_str = 'Ошибка парсинга JSON: ' || SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка парсинга JSON в parse_request_for_check_client_data', 
            'parse_request_for_check_client_data', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                '_method', _method,
                '_request', _request
            ), 
            v_context
        );
        response = jsonb_build_object(
            'error', 'Ошибка парсинга JSON: ' || SQLERRM
        )::VARCHAR;
        RETURN;
    END;

    -- Извлечение данных из JSON с учетом NULL для отсутствующих нод и сохранением пустых строк
    v_business_key = CASE WHEN v_json ? 'business-key' THEN v_json->>'business-key' ELSE NULL END;
    v_req_sum = CASE WHEN v_json ? 'req_sum' THEN NULLIF(v_json->>'req_sum', '')::NUMERIC ELSE NULL END;
    v_req_term = CASE WHEN v_json ? 'req_term' THEN v_json->>'req_term' ELSE NULL END;
    v_lastname = CASE WHEN v_json ? 'lastname' THEN v_json->>'lastname' ELSE NULL END;
    v_firstname = CASE WHEN v_json ? 'firstname' THEN v_json->>'firstname' ELSE NULL END;
    v_patronimic = CASE WHEN v_json ? 'patronimic' THEN v_json->>'patronimic' ELSE NULL END;
    v_birthday = CASE WHEN v_json ? 'birthday' THEN NULLIF(v_json->>'birthday', '')::DATE ELSE NULL END;
    v_phone_mobile = CASE WHEN v_json ? 'phone_mobile' THEN v_json->>'phone_mobile' ELSE NULL END;
    v_email = CASE WHEN v_json ? 'email' THEN v_json->>'email' ELSE NULL END;
    v_inn = CASE WHEN v_json ? 'inn' THEN v_json->>'inn' ELSE NULL END;
    v_gender = CASE WHEN v_json ? 'gender' THEN v_json->>'gender' ELSE NULL END;
    v_pass_serial = CASE WHEN v_json ? 'pass_serial' THEN v_json->>'pass_serial' ELSE NULL END;
    v_pass_number = CASE WHEN v_json ? 'pass_number' THEN v_json->>'pass_number' ELSE NULL END;
    v_pass_issuer = CASE WHEN v_json ? 'pass_issuer' THEN v_json->>'pass_issuer' ELSE NULL END;
    v_pass_issuer_code = CASE WHEN v_json ? 'pass_issuer_code' THEN v_json->>'pass_issuer_code' ELSE NULL END;
    v_pass_issue_date = CASE WHEN v_json ? 'pass_issue_date' THEN NULLIF(v_json->>'pass_issue_date', '')::DATE ELSE NULL END;
    v_birthplace = CASE WHEN v_json ? 'birthplace' THEN v_json->>'birthplace' ELSE NULL END;
    v_reg_address = CASE WHEN v_json ? 'reg_address' THEN v_json->>'reg_address' ELSE NULL END;
    v_fact_address = CASE WHEN v_json ? 'fact_address' THEN v_json->>'fact_address' ELSE NULL END;
    v_family_status = CASE WHEN v_json ? 'family_status' THEN v_json->>'family_status' ELSE NULL END;
    v_emloyment_type = CASE WHEN v_json ? 'emloyment_type' THEN v_json->>'emloyment_type' ELSE NULL END;
    v_organization_type = CASE WHEN v_json ? 'organization_type' THEN v_json->>'organization_type' ELSE NULL END;
    v_company_occupation = CASE WHEN v_json ? 'company_occupation' THEN v_json->>'company_occupation' ELSE NULL END;
    v_position_type = CASE WHEN v_json ? 'position_type' THEN v_json->>'position_type' ELSE NULL END;
    v_last_work_term = CASE WHEN v_json ? 'last_work_term' THEN v_json->>'last_work_term' ELSE NULL END;
    v_monthly_income = CASE WHEN v_json ? 'monthly_income' THEN NULLIF(v_json->>'monthly_income', '')::NUMERIC ELSE NULL END;

    -- Проверка обязательных полей
    IF v_lastname IS NULL OR v_req_sum IS NULL
        OR v_firstname IS NULL OR v_pass_serial IS NULL
        OR v_pass_number IS NULL THEN
        result = -1;
        result_str = 'Ошибка: обязательные поля не заполнены';
        response = jsonb_build_object(
            'error', 'Обязательные поля (lastname, req_sum, firstname, pass_serial, pass_number) не заполнены'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Инициализация флагов
    v_is_black_list = 'false';
    v_is_active_debt = 'false';
    v_is_debt_holiday = 'false';

    -- Обработка кода подразделения паспорта
    IF v_pass_issuer_code IS NOT NULL AND v_pass_issuer_code !~* '^\d+$' THEN
        v_pass_issuer_code = REPLACE(v_pass_issuer_code, ' ', '');
        v_pass_issuer_code = REPLACE(v_pass_issuer_code, '-', '');
        v_pass_issuer_code = REPLACE(v_pass_issuer_code, '_', '');

        IF CHAR_LENGTH(v_pass_issuer_code) = 6 THEN
            v_pass_issuer_code = LEFT(v_pass_issuer_code, 3) || '-' || RIGHT(v_pass_issuer_code, 3);
        END IF;
    END IF;

    -- Обработка номера телефона
    IF v_phone_mobile IS NOT NULL AND LENGTH(v_phone_mobile) = 10 THEN
        v_phone_mobile = '+7' || v_phone_mobile;
    END IF;

    -- Вставка данных в таблицу
    INSERT INTO eis_processes.check_client_data (
        business_key,
        req_sum,
        req_term,
        lastname,
        firstname,
        patronimic,
        birthday,
        phone_mobile,
        e_mail,
        inn,
        gender,
        pass_serial,
        pass_number,
        pass_issuer,
        pass_issuer_code,
        pass_issue_date,
        birthplace,
        reg_address,
        fact_address,
        family_status,
        emloyment_type,
        organization_type,
        company_occupation,
        position_type,
        last_work_term,
        monthly_income
    )
    VALUES (
        v_business_key,
        v_req_sum,
        v_req_term,
        v_lastname,
        v_firstname,
        v_patronimic,
        v_birthday,
        v_phone_mobile,
        v_email,
        v_inn,
        v_gender,
        v_pass_serial,
        v_pass_number,
        v_pass_issuer,
        v_pass_issuer_code,
        v_pass_issue_date,
        v_birthplace,
        v_reg_address,
        v_fact_address,
        v_family_status,
        v_emloyment_type,
        v_organization_type,
        v_company_occupation,
        v_position_type,
        v_last_work_term,
        v_monthly_income
    );

    -- Определение ключа заемщика
    SELECT s.v_borrower_key
    FROM score.find_borrower_by_args(
        v_lastname,
        v_firstname,
        v_patronimic,
        v_birthday,
        v_pass_serial,
        v_pass_number,
        '',
        '',
        '',
        v_phone_mobile
    ) AS s
    INTO v_borrower_key;

    -- Проверка задолженности и черных списков
    IF v_borrower_key IS NOT NULL THEN
        -- Проверка текущей задолженности
        IF score.check_debt_by_borrower(v_borrower_key) = -1
            OR score.check_debt_by_phone(v_phone_mobile) = -1
            OR score.check_debt_by_pass(v_pass_serial, v_pass_number) = -1
        THEN 
            v_is_active_debt = 'true';
        END IF;

        -- Проверка во внутренних черных списках
        IF borrowers.check_blacklist_by_object(1, v_borrower_key) = -1
            OR public.check_blacklist(v_borrower_key) = -1
        THEN
            v_is_black_list = 'true';
        END IF;

        -- Проверка статуса отпуска по задолженности
        IF eis_processes.check_vacation(v_pass_serial, v_pass_number, v_phone_mobile) = -1 THEN
            v_is_debt_holiday = 'true';
        END IF;
    END IF;

    -- Проверка во внешних черных списках
    IF v_is_black_list = 'false' THEN
        IF blacklists.check_black_list_manual(v_lastname, v_firstname, v_patronimic, v_birthday) = 1 THEN
            v_is_black_list = 'true';
        END IF;
    END IF;

    -- Проверка паспорта в черных списках
    IF v_is_black_list = 'false' THEN
        IF eis_processes.check_blacklist_passport(v_pass_serial, v_pass_number) = -1 THEN
            v_is_black_list = 'true';
        END IF;
    END IF;

    -- Формирование JSON-ответа
    response = jsonb_build_object(
        'is_black_list', v_is_black_list,
        'is_active_debt', v_is_active_debt,
        'is_debt_holiday', v_is_debt_holiday
    )::VARCHAR;

    result = 1;
    result_str = 'Ok';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка неожиданных ошибок
    result = -1;
    result_str = SQLERRM;
    GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
    PERFORM api.add_log(
        'ERROR', 
        'Неожиданная ошибка в parse_request_for_check_client_data', 
        'parse_request_for_check_client_data', 
        jsonb_build_object(
            'sql_error', SQLERRM,
            '_method', _method,
            '_request', _request
        ), 
        v_context
    );
    response = jsonb_build_object(
        'error', 'Неожиданная ошибка: ' || SQLERRM
    )::VARCHAR;
    RETURN;
END;
$function$
;

-- DROP FUNCTION api.parse_request_for_get_approved_for_transfer_2(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.parse_request_for_get_approved_for_transfer_2(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
/*<description>
	Получить одобрение на перевод (кредитные риски), принимающий JSON и возвращающий JSON
</description>
<history_list>
    <item><date_m>02.09.2025</date_m><task_n>54706355</task_n><author>Крупская И.Е.</author></item>
    <item><date_m>26.09.2025</date_m><task_n></task_n><author>xtetis</author></item>
</history_list>*/
    v_json JSONB; -- Переменная для хранения входного JSON
    v_req_id BIGINT;
    v_business_key VARCHAR;
    v_transfer_sum NUMERIC;
    v_lastname VARCHAR;
    v_firstname VARCHAR;
    v_patronimic VARCHAR;
    v_birthday DATE;
    v_gender VARCHAR;
    v_phone_mobile VARCHAR;
    v_email VARCHAR;
    v_snils VARCHAR;
    v_inn VARCHAR;
    v_pass_serial VARCHAR;
    v_pass_number VARCHAR;
    v_pass_issuer_code VARCHAR;
    v_approved_for_transfer_key INTEGER;
    v_result VARCHAR;
    v_payment_method_id VARCHAR;
    v_card_mask VARCHAR;
    v_card_expiration_date VARCHAR;
    v_gateway_name VARCHAR;
    v_card_token VARCHAR;
    v_sbp_bank_key VARCHAR;
    v_pam_fio VARCHAR;
    _user_key INTEGER;
    v_db_user_name VARCHAR;
    v_db_pwd VARCHAR;
    v_db_host VARCHAR;
    v_db_name VARCHAR;
    v_connect_name VARCHAR;
    v_connect_string VARCHAR;
    v_query VARCHAR;
    _dblink_result VARCHAR;
    _dblink_query_result INTEGER;
    v_application_key INTEGER;
    v_exp_month VARCHAR;
    v_exp_year VARCHAR;
    v_account_term DATE;
    v_wdw_method_key INTEGER;
    v_full_identification VARCHAR;
    v_tmp_permissible_loan_key BIGINT;
    v_application_uprid_key INTEGER;
    v_context VARCHAR; -- Для логирования контекста ошибки
BEGIN
    -- Инициализация выходных параметров
    result = 1;
    result_str = 'OK';
    response = '{}';

    -- Парсинг входного JSON
    BEGIN
        v_json = _request::JSONB;
    EXCEPTION WHEN OTHERS THEN
        result = -1;
        result_str = 'Ошибка парсинга JSON: ' || SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка парсинга JSON в parse_request_for_get_approved_for_transfer_2', 
            'parse_request_for_get_approved_for_transfer_2', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                '_method', _method,
                '_request', _request
            ), 
            v_context
        );
        response = jsonb_build_object(
            'error', 'Ошибка парсинга JSON: ' || SQLERRM
        )::VARCHAR;
        RETURN;
    END;

    -- Извлечение данных из JSON с учетом NULL для отсутствующих нод и сохранением пустых строк
    v_business_key = CASE WHEN v_json ? 'business-key' THEN v_json->>'business-key' ELSE NULL END;
    v_transfer_sum = CASE WHEN v_json ? 'transfer_sum' THEN NULLIF(v_json->>'transfer_sum', '')::NUMERIC ELSE NULL END;
    v_lastname = CASE WHEN v_json ? 'lastname' THEN v_json->>'lastname' ELSE NULL END;
    v_firstname = CASE WHEN v_json ? 'firstname' THEN v_json->>'firstname' ELSE NULL END;
    v_patronimic = CASE WHEN v_json ? 'patronimic' THEN v_json->>'patronimic' ELSE NULL END;
    v_birthday = CASE WHEN v_json ? 'birthday' THEN NULLIF(v_json->>'birthday', '')::DATE ELSE NULL END;
    v_gender = CASE WHEN v_json ? 'gender' THEN v_json->>'gender' ELSE NULL END;
    v_phone_mobile = CASE WHEN v_json ? 'phone_mobile' THEN v_json->>'phone_mobile' ELSE NULL END;
    v_email = CASE WHEN v_json ? 'email' THEN v_json->>'email' ELSE NULL END;
    v_snils = CASE WHEN v_json ? 'snils' THEN v_json->>'snils' ELSE NULL END;
    v_inn = CASE WHEN v_json ? 'inn' THEN v_json->>'inn' ELSE NULL END;
    v_pass_serial = CASE WHEN v_json ? 'pass_serial' THEN v_json->>'pass_serial' ELSE NULL END;
    v_pass_number = CASE WHEN v_json ? 'pass_number' THEN v_json->>'pass_number' ELSE NULL END;
    v_pass_issuer_code = CASE WHEN v_json ? 'pass_issuer_code' THEN v_json->>'pass_issuer_code' ELSE NULL END;
    v_payment_method_id = CASE WHEN v_json ? 'payment_method_id' THEN v_json->>'payment_method_id' ELSE NULL END;
    v_card_mask = CASE WHEN v_json ? 'card_mask' THEN v_json->>'card_mask' ELSE NULL END;
    v_card_expiration_date = CASE WHEN v_json ? 'card_expiration_date' THEN v_json->>'card_expiration_date' ELSE NULL END;
    v_gateway_name = CASE WHEN v_json ? 'gateway_name' THEN v_json->>'gateway_name' ELSE NULL END;
    v_card_token = CASE WHEN v_json ? 'card_token' THEN v_json->>'card_token' ELSE NULL END;
    v_sbp_bank_key = CASE WHEN v_json ? 'sbp_bank_key' THEN v_json->>'sbp_bank_key' ELSE NULL END;
    v_pam_fio = CASE WHEN v_json ? 'pam_fio' THEN v_json->>'pam_fio' ELSE NULL END;
    v_full_identification = CASE WHEN v_json ? 'full_identification' THEN v_json->>'full_identification' ELSE NULL END;
    v_tmp_permissible_loan_key = CASE WHEN v_json ? 'agreed_loan_terms_id' THEN NULLIF(v_json->>'agreed_loan_terms_id', '')::BIGINT ELSE NULL END;

    -- Проверка обязательных полей
    IF v_business_key IS NULL OR v_transfer_sum IS NULL THEN
        result = -1;
        result_str = 'Ошибка парсинга входных данных';
        response = jsonb_build_object(
            'error', 'Обязательные поля (business-key, transfer_sum) не заполнены'
        )::VARCHAR;
        
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка проверки обязательных полей в parse_request_for_get_approved_for_transfer_2', 
            'parse_request_for_get_approved_for_transfer_2', 
            jsonb_build_object(
                '_method', _method,
                '_request', _request
            ), 
            NULL
        );
        response = jsonb_build_object(
            'error', 'Обязательные поля (business-key, transfer_sum) не заполнены'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Обработка номера телефона
    IF v_phone_mobile IS NOT NULL AND LENGTH(v_phone_mobile) = 10 THEN
        v_phone_mobile = '+7' || v_phone_mobile;
    END IF;

    v_card_mask = REPLACE(COALESCE(v_card_mask, ''), ' ', '');
    v_req_id = NULL;

    -- Вставка данных в таблицу
    INSERT INTO online_processes.approved_for_transfer (
        business_key,
        req_id,
        transfer_sum,
        lastname,
        firstname,
        patronimic,
        birthday,
        gender,
        phone_mobile,
        email,
        snils,
        inn,
        pass_serial,
        pass_number,
        pass_issuer_code,
        payment_method_id,
        card_mask,
        card_expiration_date,
        gateway_name,
        card_token,
        sbp_bank_key,
        pam_fio,
        full_identification,
        agreed_loan_terms_id
    )
    VALUES (
        v_business_key,
        v_req_id,
        v_transfer_sum,
        v_lastname,
        v_firstname,
        v_patronimic,
        v_birthday,
        v_gender,
        v_phone_mobile,
        v_email,
        v_snils,
        v_inn,
        v_pass_serial,
        v_pass_number,
        v_pass_issuer_code,
        v_payment_method_id,
        v_card_mask,
        v_card_expiration_date,
        v_gateway_name,
        v_card_token,
        v_sbp_bank_key,
        v_pam_fio,
        v_full_identification,
        v_tmp_permissible_loan_key
    )
    RETURNING approved_for_transfer_key
    INTO v_approved_for_transfer_key;

    -- Получение ключа заявки
    SELECT a.application_key
    FROM online_processes.loanapp_review l
    JOIN online_processes.app_loanapp_review a ON a.loanapp_review_id = l.loanapp_review_id
    WHERE l.business_key = v_business_key
    ORDER BY l.loanapp_review_id DESC
    LIMIT 1
    INTO v_application_key;

    -- Проверка открытой заявки
    PERFORM *
    FROM loan_issue.application a
    WHERE a.application_key = v_application_key
        AND a.application_status = 'opened';

    IF NOT FOUND THEN
        result = -1;
        result_str = 'Не найдена открытая заявка';
        response = jsonb_build_object(
            'error', 'Не найдена открытая заявка'
        )::VARCHAR;
        
        PERFORM api.add_log(
            'ERROR', 
            'Не найдена открытая заявка в parse_request_for_get_approved_for_transfer_2', 
            'parse_request_for_get_approved_for_transfer_2', 
            jsonb_build_object(
                '_method', _method,
                '_request', _request,
                'business_key', v_business_key
            ), 
            NULL
        );
        response = jsonb_build_object(
            'error', 'Не найдена открытая заявка'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Проверка допустимого кредита
    PERFORM *
    FROM loan_issue.tmp_permissible_loan t
    WHERE t.key = v_tmp_permissible_loan_key;

    IF NOT FOUND THEN
        result = 1;
        result_str = 'Не найден указанный оффер, обновите/пересчитайте предложения';
        response = jsonb_build_object(
            'result', 'INCORRECT_LOAN_TERMS_ID'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Формирование ответа для успеха
    response = jsonb_build_object(
        'result', 'APPROVE_LAUNCHED'
    )::VARCHAR;

    -- Обработка срока действия карты
    v_exp_month = LEFT(COALESCE(v_card_expiration_date, ''), 2);
    v_exp_year = RIGHT(COALESCE(v_card_expiration_date, ''), 2);
    v_account_term = ('01.' || v_exp_month || '.' || v_exp_year)::DATE + '1 month'::INTERVAL - '1 day'::INTERVAL;

    -- Определение метода выдачи
    IF v_payment_method_id = 'CARD' THEN
        IF v_gateway_name = 'ТКБ' THEN
            v_wdw_method_key = 110;
        ELSE
            v_wdw_method_key = 10;
        END IF;
    ELSE
        v_wdw_method_key = 20;
    END IF;

    -- Обновление или вставка в application_account
    PERFORM *
    FROM loan_issue.application_account a
    WHERE a.application_key = v_application_key;

    IF FOUND THEN
        UPDATE loan_issue.application_account a
        SET wdw_method_key = v_wdw_method_key,
            account_hidden = v_card_mask,
            account_term = v_account_term,
            account = v_card_token,
            bank_id = v_sbp_bank_key,
            pam_fio = v_pam_fio
        WHERE a.application_key = v_application_key;
    ELSE
        INSERT INTO loan_issue.application_account (
            application_key,
            wdw_method_key,
            account_hidden,
            account_term,
            account,
            bank_id,
            pam_fio
        )
        VALUES (
            v_application_key,
            v_wdw_method_key,
            v_card_mask,
            v_account_term,
            v_card_token,
            v_sbp_bank_key,
            v_pam_fio
        );
    END IF;

    -- Обновление application
    UPDATE loan_issue.application a
    SET withdrawal_method = v_wdw_method_key
    WHERE a.application_key = v_application_key;

    -- Обновление loans
    UPDATE public.loans a
    SET non_cash = v_wdw_method_key
    WHERE a.application_key = v_application_key;

    -- Сохранение ИНН
    BEGIN
        SELECT t.application_uprid_key
        FROM loan_issue.application_uprid t
        WHERE t.application_key = v_application_key
        LIMIT 1
        INTO v_application_uprid_key;
        v_inn = COALESCE(v_inn, '');

        IF v_inn <> '' THEN
            IF v_application_uprid_key IS NULL THEN
                INSERT INTO loan_issue.application_uprid (
                    application_key,
                    ext_object_type,
                    ext_object_key,
                    inn_status,
                    inn
                )
                VALUES (
                    v_application_key,
                    'APPROVE',
                    v_application_key,
                    'FOUND',
                    v_inn
                );
            ELSE
                UPDATE loan_issue.application_uprid
                SET inn = v_inn
                WHERE application_uprid_key = v_application_uprid_key;
            END IF;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        -- Игнорируем ошибки сохранения ИНН
        NULL;
    END;

    -- Асинхронный запуск процедуры получения одобрения на перевод
    BEGIN
        _user_key = online_back.get_online_back_prod_param_val('USER_KEY')::INTEGER;

        SELECT u.user_name, u.pass
        FROM public.t_users u
        WHERE u.user_key = _user_key
        INTO v_db_user_name, v_db_pwd;

        v_db_host = '127.0.0.1';
        v_db_name = current_database();

        v_connect_name = 'approved_for_transfer_' || v_application_key::VARCHAR || '_' || MD5(CLOCK_TIMESTAMP()::VARCHAR)::VARCHAR;
        v_connect_string = 'hostaddr=' || v_db_host
            || ' dbname=' || v_db_name
            || ' user=' || v_db_user_name
            || ' password=' || v_db_pwd;

        v_query = 'SELECT * FROM eis_processes.get_approved_for_transfer('
            || v_application_key::VARCHAR || ', '
            || '''' || COALESCE(v_full_identification, '') || ''', '
            || '''' || v_business_key || ''')';

        SELECT * FROM dblink.dblink_connect(v_connect_name, v_connect_string)
        INTO _dblink_result;

        SELECT * FROM dblink.dblink_send_query(v_connect_name, v_query)
        INTO _dblink_query_result;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка асинхронного вызова в parse_request_for_get_approved_for_transfer_2', 
            'parse_request_for_get_approved_for_transfer_2', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                'application_key', v_application_key,
                'business_key', v_business_key
            ), 
            v_context
        );
        -- Продолжаем, не прерывая
    END;

    result = 1;
    result_str = 'Ok';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка неожиданных ошибок
    result = -1;
    result_str = SQLERRM;
    GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
    PERFORM api.add_log(
        'ERROR', 
        'Неожиданная ошибка в parse_request_for_get_approved_for_transfer_2', 
        'parse_request_for_get_approved_for_transfer_2', 
        jsonb_build_object(
            'sql_error', SQLERRM,
            '_method', _method,
            '_request', _request
        ), 
        v_context
    );
    response = jsonb_build_object(
        'error', 'Неожиданная ошибка: ' || SQLERRM
    )::VARCHAR;
    RETURN;
END;
$function$
;

-- DROP FUNCTION api.parse_request_for_loan_docs_leasing(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.parse_request_for_loan_docs_leasing(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
/*<description>
	Сформировать ссылки документов по займу Лизинг, принимающий JSON и возвращающий JSON
</description>
<history_list>
    <item><date_m>17.09.2025</date_m><task_n>55444014</task_n><author>Крупская И.Е.</author></item>
    <item><date_m>26.09.2025</date_m><task_n></task_n><author>xtetis</author></item>
</history_list>*/
    v_json JSONB; -- Переменная для хранения входного JSON
    v_business_key VARCHAR;
    v_application_key INTEGER;
    v_tmp_permissible_loan_key BIGINT;
    _user_key integer;
    set_res integer;
    v_db_user_name varchar;
    v_db_pwd varchar;
    v_db_host varchar;
    v_db_name varchar;
    v_connect_name varchar;
    v_connect_string varchar;
    v_query varchar;
    _dblink_result varchar;
    _dblink_query_result integer;
    v_ins_premium NUMERIC;
    v_insurance BOOLEAN;
    v_json_params VARCHAR;
    v_context VARCHAR; -- Для логирования контекста ошибки
BEGIN
    -- Инициализация выходных параметров
    result = 1;
    result_str = 'OK';
    response = '{}';

    -- Парсинг входного JSON
    BEGIN
        v_json = _request::JSONB;
    EXCEPTION WHEN OTHERS THEN
        result = -1;
        result_str = 'Ошибка парсинга JSON: ' || SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка парсинга JSON в parse_request_for_loan_docs_leasing', 
            'parse_request_for_loan_docs_leasing', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                '_method', _method,
                '_request', _request
            ), 
            v_context
        );
        response = jsonb_build_object(
            'error', 'Ошибка парсинга JSON: ' || SQLERRM
        )::VARCHAR;
        RETURN;
    END;

    -- Извлечение данных из JSON с учетом NULL для отсутствующих нод и сохранением пустых строк
    v_business_key = CASE WHEN v_json ? 'business-key' THEN v_json->>'business-key' ELSE NULL END;
    v_tmp_permissible_loan_key = CASE WHEN v_json ? 'agreed_loan_terms_id' THEN NULLIF(v_json->>'agreed_loan_terms_id', '')::BIGINT ELSE NULL END;

    -- Проверка обязательных полей
    IF v_business_key IS NULL OR v_tmp_permissible_loan_key IS NULL THEN
        result = -1;
        result_str = 'Ошибка: обязательные поля не заполнены';
        response = jsonb_build_object(
            'error', 'Обязательные поля (business_key, agreed_loan_terms_id) не заполнены'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Получение ключа заявки
    SELECT a.application_key
    FROM eis_processes.loanapp_review_leasing l
    JOIN eis_processes.app_loanapp_review_leasing a ON a.loanapp_review_id = l.loanapp_review_id
    WHERE l.business_key = v_business_key
    ORDER BY l.loanapp_review_id DESC
    LIMIT 1
    INTO v_application_key;

    -- Проверка наличия открытой заявки
    PERFORM 1
    FROM loan_issue.application a
    WHERE a.application_key = v_application_key
        AND a.application_status = 'opened';

    IF NOT FOUND THEN
        result = -1;
        result_str = 'Не найдена открытая заявка';
        response = jsonb_build_object(
            'error', 'Не найдена открытая заявка'
        )::VARCHAR;
        
        PERFORM api.add_log(
            'ERROR', 
            'Не найдена открытая заявка в parse_request_for_loan_docs_leasing', 
            'parse_request_for_loan_docs_leasing', 
            jsonb_build_object(
                '_method', _method,
                'business_key', v_business_key
            ), 
            v_context
        );
        RETURN;
    END IF;

    -- Проверка наличия оффера
    PERFORM *
    FROM loan_issue.tmp_permissible_loan t
    WHERE t.key = v_tmp_permissible_loan_key;

    IF NOT FOUND THEN
        result = -1;
        result_str = 'Не найден указанный оффер, обновите/пересчитайте предложения';
        response = jsonb_build_object(
            'error', 'Не найден указанный оффер, обновите/пересчитайте предложения'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Установка параметров контракта
    SELECT g.*
    FROM eis_processes.set_contract_parametrs_leasing(v_tmp_permissible_loan_key) g
    INTO set_res;

    IF set_res < 0 THEN
    	result = -1;
        result_str = 'Не удалось подтвердить указанный оффер, обновите/пересчитайте предложения';
        response = jsonb_build_object(
            'error', 'Не удалось подтвердить указанный оффер, обновите/пересчитайте предложения'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Получение премии по страховке
    SELECT t.ins_premium
    FROM loan_issue.tmp_permissible_loan t
    WHERE t.key = v_tmp_permissible_loan_key
    INTO v_ins_premium;

    IF COALESCE(v_ins_premium, 0) > 0 THEN
    	v_insurance = TRUE;
    ELSE
    	v_insurance = FALSE;
    END IF;
    
    -- Сборка JSON с переменными для документов
    SELECT g.json_params
    FROM eis_processes.get_loan_docs_params_json_leasing(v_tmp_permissible_loan_key::INTEGER, v_insurance) AS g
    INTO v_json_params;

    -- Асинхронный запуск процедуры формирования ссылок на файлы
    _user_key = online_back.get_online_back_prod_param_val('USER_KEY')::INTEGER;

    SELECT u.user_name, u.pass
    FROM public.t_users u
    WHERE u.user_key = _user_key
    INTO v_db_user_name, v_db_pwd;

    v_db_host = '127.0.0.1';
    v_db_name = current_database();

    -- Соединение с БД
    v_connect_name = 'generate_files_leasing_' || v_tmp_permissible_loan_key::VARCHAR || '_'
        || MD5(clock_timestamp()::VARCHAR)::VARCHAR;
    v_connect_string = 'hostaddr=' || v_db_host
        || ' dbname=' || v_db_name
        || ' user=' || v_db_user_name
        || ' password=' || v_db_pwd;

    -- Запрос
    v_query = 'SELECT * FROM eis_processes.generate_files_leasing('
        || v_tmp_permissible_loan_key::VARCHAR || ', '
        || '''' || v_business_key || ''')';

    -- Асинхронный вызов
    BEGIN
        PERFORM dblink.dblink_connect(v_connect_name, v_connect_string);
        PERFORM dblink.dblink_send_query(v_connect_name, v_query);
    END;

    response = COALESCE(v_json_params, '{}');

    result = 1;
    result_str = 'Ok';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка неожиданных ошибок
    result = -1;
    result_str = SQLERRM;
    GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
    PERFORM api.add_log(
        'ERROR', 
        'Неожиданная ошибка в parse_request_for_loan_docs_leasing', 
        'parse_request_for_loan_docs_leasing', 
        jsonb_build_object(
            'sql_error', SQLERRM,
            '_method', _method,
            '_request', _request
        ), 
        v_context
    );
    response = jsonb_build_object(
        'error', 'Неожиданная ошибка: ' || SQLERRM
    )::VARCHAR;
    RETURN;
END;
$function$
;

-- DROP FUNCTION api.parse_request_for_loan_finalization_leasing(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.parse_request_for_loan_finalization_leasing(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
/*<description>
	Финализация выдачи займа Лизинг, принимающий JSON и возвращающий JSON
</description>
<history_list>
    <item><date_m>17.09.2025</date_m><task_n>55444014</task_n><author>Крупская И.Е.</author></item>
    <item><date_m>26.09.2025</date_m><task_n></task_n><author>xtetis</author></item>
    <item><date_m>26.09.2025</date_m><task_n>Unknown</task_n><author>Updated for NULL handling</author></item>
</history_list>*/
    v_json JSONB; -- Переменная для хранения входного JSON
    v_loan_issue_fact JSONB; -- Вложенный объект для факта выдачи займа
    v_business_key VARCHAR;
    v_tmp_permissible_loan_key INTEGER;
    v_application_key INTEGER;
    v_transfer_money_dt TIMESTAMP;
    v_loan_key INTEGER;
    v_issued BOOLEAN;
    v_loans_history_key BIGINT;
    v_sign_docs_creation_date DATE;
    v_loan_sum NUMERIC;
    v_day_rate NUMERIC;
    v_diff INTEGER;
    v_correction_interests NUMERIC;
    v_overpayment_sum NUMERIC;
    v_repayment_schedule_key INTEGER;
    v_overpayment NUMERIC;
    v_refunds NUMERIC;
    v_permissible_loans_period INTEGER;
    v_loan_term INTEGER;
    v_phone_number VARCHAR;
    v_phone_approval_send_dt TIMESTAMP;
    v_phone_approval_code VARCHAR;
    v_phone_approval_receive_code_dt TIMESTAMP;
    v_phone_number_sign VARCHAR;
    v_sign_docs_send_dt TIMESTAMP;
    v_sign_docs_code VARCHAR;
    v_sign_docs_receive_code_dt TIMESTAMP;
    v_non_cash INTEGER;
    v_payment_info VARCHAR;
    v_context VARCHAR; -- Для логирования контекста ошибки
BEGIN
    -- Инициализация выходных параметров
    result = 1;
    result_str = 'OK';
    response = '{}';

    -- Парсинг входного JSON
    BEGIN
        v_json = _request::JSONB;
    EXCEPTION WHEN OTHERS THEN
        result = -1;
        result_str = 'Ошибка парсинга JSON: ' || SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка парсинга JSON в parse_request_for_loan_finalization_leasing', 
            'parse_request_for_loan_finalization_leasing', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                '_method', _method,
                '_request', _request
            ), 
            v_context
        );
        response = jsonb_build_object(
            'error', 'Ошибка парсинга JSON: ' || SQLERRM
        )::VARCHAR;
        RETURN;
    END;

    -- Извлечение данных из JSON с учетом NULL для отсутствующих нод и сохранением пустых строк
    v_business_key = CASE WHEN v_json ? 'business-key' THEN v_json->>'business-key' ELSE NULL END;
    v_tmp_permissible_loan_key = CASE WHEN v_json ? 'agreed_loan_terms_id' THEN NULLIF(v_json->>'agreed_loan_terms_id', '')::INTEGER ELSE NULL END;
    v_transfer_money_dt = CASE WHEN v_json ? 'transfer_money_dt' THEN NULLIF(v_json->>'transfer_money_dt', '')::TIMESTAMP ELSE NULL END;
    v_payment_info = CASE WHEN v_json ? 'payment_info' THEN v_json->>'payment_info' ELSE NULL END;

    -- Извлечение вложенного объекта loan_issue_fact
    v_loan_issue_fact = CASE WHEN v_json ? 'loan_issue_fact' THEN v_json->'loan_issue_fact' ELSE NULL END;
    v_phone_number = CASE WHEN v_loan_issue_fact ? 'phone_number' THEN v_loan_issue_fact->>'phone_number' ELSE NULL END;
    v_phone_approval_send_dt = CASE WHEN v_loan_issue_fact ? 'phone_approval_send_dt' THEN NULLIF(v_loan_issue_fact->>'phone_approval_send_dt', '')::TIMESTAMP ELSE NULL END;
    v_phone_approval_code = CASE WHEN v_loan_issue_fact ? 'phone_approval_code' THEN v_loan_issue_fact->>'phone_approval_code' ELSE NULL END;
    v_phone_approval_receive_code_dt = CASE WHEN v_loan_issue_fact ? 'phone_approval_receive_code_dt' THEN NULLIF(v_loan_issue_fact->>'phone_approval_receive_code_dt', '')::TIMESTAMP ELSE NULL END;
    v_phone_number_sign = CASE WHEN v_loan_issue_fact ? 'phone_number_sign' THEN v_loan_issue_fact->>'phone_number_sign' ELSE NULL END;
    v_sign_docs_send_dt = CASE WHEN v_loan_issue_fact ? 'sign_docs_send_dt' THEN NULLIF(v_loan_issue_fact->>'sign_docs_send_dt', '')::TIMESTAMP ELSE NULL END;
    v_sign_docs_code = CASE WHEN v_loan_issue_fact ? 'sign_docs_code' THEN v_loan_issue_fact->>'sign_docs_code' ELSE NULL END;
    v_sign_docs_receive_code_dt = CASE WHEN v_loan_issue_fact ? 'sign_docs_receive_code_dt' THEN NULLIF(v_loan_issue_fact->>'sign_docs_receive_code_dt', '')::TIMESTAMP ELSE NULL END;

    -- Проверка обязательных полей
    IF v_business_key IS NULL OR v_tmp_permissible_loan_key IS NULL THEN
        result = -1;
        result_str = 'Ошибка: обязательные поля не заполнены';
        response = jsonb_build_object(
            'error', 'Обязательные поля (business_key, agreed_loan_terms_id) не заполнены'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Установка даты перевода, если не указана
    v_transfer_money_dt = COALESCE(v_transfer_money_dt, CURRENT_TIMESTAMP);

    -- Получение ключа заявки
    SELECT a.application_key
    FROM eis_processes.loanapp_review_leasing l
    JOIN eis_processes.app_loanapp_review_leasing a ON a.loanapp_review_id = l.loanapp_review_id
    WHERE l.business_key = v_business_key
    ORDER BY l.loanapp_review_id DESC
    LIMIT 1
    INTO v_application_key;

    -- Получение данных по займу
    SELECT s.loan_key, s.issued, s.creation_date, s.loan_sum, s.loan_term, s.non_cash
    FROM public.loans s
    WHERE s.application_key = v_application_key
    INTO v_loan_key, v_issued, v_sign_docs_creation_date, v_loan_sum, v_loan_term, v_non_cash;

    -- Вставка факта выдачи, если указан номер телефона
    IF v_phone_number IS NOT NULL THEN
    	INSERT INTO online_processes.loan_issue_fact (
        	business_key, req_id, loan_key, phone_number, phone_approval_send_dt,
            phone_approval_code, phone_approval_receive_code_dt, phone_number_sign,
            sign_docs_send_dt, sign_docs_code, sign_docs_receive_code_dt, payment_info
        )
        VALUES (
            v_business_key, NULL, v_loan_key, v_phone_number, v_phone_approval_send_dt,
        	v_phone_approval_code, v_phone_approval_receive_code_dt, v_phone_number_sign,
            v_sign_docs_send_dt, v_sign_docs_code, v_sign_docs_receive_code_dt, v_payment_info
        );
    END IF;

    -- Если займ еще не выдан
    IF v_issued IS NOT TRUE THEN
        -- Копирование текущих данных в историю
        INSERT INTO public.loans_history (
        	loan_key, borrower_key, for_what_purpose, cause_of_failure, priority_1, priority_2, priority_3, requested_amount, requested_term,
            second_loan, type_credit_product_key, test_pass_age, test_pass_citizenship, test_pass_registration, test_pass_martial_status,
            test_pass_nmb_of_children, test_state_business, test_phone_mobile_phone, test_phone_mobile_phone_spouse, test_phone_third_person,
            test_adds_call_home_phone, test_adds_call_spouse, test_adds_call_third_person, test_fixed_income_call_work,
            test_fixed_income_call_spouse, test_fixed_income_call_third_person, test_fixed_income_proof_of_income,
            test_fixed_income_business_card, test_fixed_income_pass, test_fixed_income_civil_servant, test_fixed_income_pension_certificate,
            test_fixed_income_savings_book, test_revenue_proof_of_income, test_revenue_civil_servant, test_revenue_call_spouse,
            test_revenue_cash_book, test_revenue_registration_vehicle, test_revenue_pension_certificate,
            test_revenue_savings_book, test_revenue_declaration, face_control, health, resolution, resolution_description,
            loan_term, loan_sum, loan_rate, loan_plan_overpayment, loan_plan_to_returns, loan_fine_rate, loan_penalty,
            loan_maximum_delay, approved_user, additional_confirmation, additional_user, approved_system, contract,
            principial_contract, creation_date, printing_documents, issued, delay, debtor, returned, canceled, canceled_decription,
            user_name, date_work, permissible_loan_key, agreed, additional_agreement, requested_period, non_cash, calc_date,
            calc_user_name, pre_agreed, test_utility_bills, test_no_debt_another_organization, loyalty_programm, subdivision_key,
            test_adds_paid_receipt_terminal, reject_reason, test_revenue_osago, cft_card_key, test_birth_certificate, test_valid_foreign_passport,
            test_house_book, test_statement_of_salary_account, cancel_reason, restructuring, early_repayment, application_key,
            closed_date, debt_relieft_type, current_dpd, calc_stop_date, calc_stop_reason, claim_right, refinance
        )
        SELECT loan_key, borrower_key, for_what_purpose, cause_of_failure, priority_1, priority_2, priority_3, requested_amount, requested_term,
            second_loan, type_credit_product_key, test_pass_age, test_pass_citizenship, test_pass_registration, test_pass_martial_status,
            test_pass_nmb_of_children, test_state_business, test_phone_mobile_phone, test_phone_mobile_phone_spouse, test_phone_third_person,
            test_adds_call_home_phone, test_adds_call_spouse, test_adds_call_third_person, test_fixed_income_call_work,
            test_fixed_income_call_spouse, test_fixed_income_call_third_person, test_fixed_income_proof_of_income,
            test_fixed_income_business_card, test_fixed_income_pass, test_fixed_income_civil_servant, test_fixed_income_pension_certificate,
            test_fixed_income_savings_book, test_revenue_proof_of_income, test_revenue_civil_servant, test_revenue_call_spouse,
            test_revenue_cash_book, test_revenue_registration_vehicle, test_revenue_pension_certificate,
            test_revenue_savings_book, test_revenue_declaration, face_control, health, resolution, resolution_description,
            loan_term, loan_sum, loan_rate, loan_plan_overpayment, loan_plan_to_returns, loan_fine_rate, loan_penalty,
            loan_maximum_delay, approved_user, additional_confirmation, additional_user, approved_system, contract,
            principial_contract, creation_date, printing_documents, issued, delay, debtor, returned, canceled, canceled_decription,
            user_name, date_work, permissible_loan_key, agreed, additional_agreement, requested_period, non_cash, calc_date,
            calc_user_name, pre_agreed, test_utility_bills, test_no_debt_another_organization, loyalty_programm, subdivision_key,
            test_adds_paid_receipt_terminal, reject_reason, test_revenue_osago, cft_card_key, test_birth_certificate, test_valid_foreign_passport,
            test_house_book, test_statement_of_salary_account, cancel_reason, restructuring, early_repayment, application_key,
            closed_date, debt_relieft_type, current_dpd, calc_stop_date, calc_stop_reason, claim_right, refinance
        FROM public.loans l
        WHERE l.loan_key = v_loan_key
        RETURNING loans_history_key
        INTO v_loans_history_key;

        -- Копирование допустимых займов в историю
        INSERT INTO public.permissible_loans_history (
        	key, loan_key, tariff_key, period_key, period, max_amount, rate, refunds, overpayment,
  			nmb_of_payments, sum_payment, bonus, tuning, discount_amount, discount_loalty_perc,
  			fixed_payment_day, rate_rs, type_repayment_schedule_key, version_number,
  			version_date, version_type, psk_percent
        )
        SELECT * FROM public.permissible_loans l
        WHERE l.loan_key = v_loan_key;

        -- Копирование графиков погашения в историю
        INSERT INTO public.repayment_schedules_history (
        	repayment_schedule_key, loan_key, payment_date, loan_sum, overpayment_sum,
  			delay, debtor, returned, permissible_loan_key, returned_date
        )
        SELECT * FROM public.repayment_schedules l
        WHERE l.loan_key = v_loan_key;

        -- Получение ставки и периода
        SELECT COALESCE(pl.rate_rs, pl.rate), pl.period
        FROM public.permissible_loans pl
        WHERE pl.loan_key = v_loan_key
        	AND pl.version_type = 0
        ORDER BY pl.key ASC
        LIMIT 1
        INTO v_day_rate, v_permissible_loans_period;

        -- Обновление даты создания займа
        UPDATE public.loans l
        SET creation_date = v_transfer_money_dt::DATE
        WHERE l.loan_key = v_loan_key;

        -- Расчет разницы в днях
        v_diff = v_transfer_money_dt::DATE - v_sign_docs_creation_date;

        -- Если разница положительная, корректируем проценты
        IF v_diff > 0 THEN
        	v_correction_interests = TRUNC(v_loan_sum * v_day_rate * v_diff / 100, 2);

            -- Обновление первого платежа
            SELECT r.overpayment_sum, r.repayment_schedule_key
            FROM public.repayment_schedules r
            WHERE r.loan_key = v_loan_key
            ORDER BY r.repayment_schedule_key ASC
            LIMIT 1
            INTO v_overpayment_sum, v_repayment_schedule_key;

            v_overpayment_sum = v_overpayment_sum - v_correction_interests;

            UPDATE public.repayment_schedules r
            SET overpayment_sum = v_overpayment_sum
            WHERE r.repayment_schedule_key = v_repayment_schedule_key;

            -- Перерасчет сумм по графику
            SELECT SUM(rs.overpayment_sum), SUM(rs.loan_sum + rs.overpayment_sum)
            FROM public.repayment_schedules rs
            WHERE rs.loan_key = v_loan_key
            INTO v_overpayment, v_refunds;

            -- Обновление permissible_loans
            UPDATE public.permissible_loans p
            SET refunds = v_refunds,
            	overpayment = v_overpayment,
                version_date = v_transfer_money_dt::DATE,
                period = v_permissible_loans_period - v_diff
            WHERE p.loan_key = v_loan_key;

            -- Обновление срока займа
            UPDATE public.loans l
            SET loan_term = v_loan_term - v_diff
            WHERE l.loan_key = v_loan_key;

        END IF;

        -- Фиксация успешной выдачи
        PERFORM * FROM eis_processes.loan_success_fix(v_application_key, v_tmp_permissible_loan_key);
	END IF;

    result = 1;
    result_str = 'Ok';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка неожиданных ошибок
    result = -1;
    result_str = SQLERRM;
    GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
    PERFORM api.add_log(
        'ERROR', 
        'Неожиданная ошибка в parse_request_for_loan_finalization_leasing', 
        'parse_request_for_loan_finalization_leasing', 
        jsonb_build_object(
            'sql_error', SQLERRM,
            '_method', _method,
            '_request', _request
        ), 
        v_context
    );
    response = jsonb_build_object(
        'error', 'Неожиданная ошибка: ' || SQLERRM
    )::VARCHAR;
    RETURN;
END;
$function$
;

-- DROP FUNCTION api.parse_request_for_loanapp_review_5(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.parse_request_for_loanapp_review_5(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
/*<description>
	Рассмотрение кредитной заявки 5, принимающий JSON и возвращающий JSON
</description>
<history_list>
    <item><date_m>02.09.2025</date_m><task_n>54706355</task_n><author>Крупская И.Е.</author></item>
    <item><date_m>26.09.2025</date_m><task_n></task_n><author>xtetis</author></item>
    <item><date_m>26.09.2025</date_m><task_n>Unknown</task_n><author>Updated for NULL handling</author></item>
</history_list>*/
    v_json JSONB; -- Переменная для хранения входного JSON
    v_agreemets_part2_md5 JSONB; -- Вложенный объект для согласий
    v_nbki_md5 VARCHAR;
    v_equifax_md5 VARCHAR;
    v_rus_standart_md5 VARCHAR;
    v_service_agreement_md5 VARCHAR;
    v_source_id VARCHAR;
    v_wm_id VARCHAR;
    v_click_id VARCHAR;
    v_offer_id VARCHAR;
    v_source_id_last VARCHAR;
    v_wm_id_last VARCHAR;
    v_click_id_last VARCHAR;
    v_offer_id_last VARCHAR;
    v_utm_medium VARCHAR;
    v_utm_campaign VARCHAR;
    v_utm_term VARCHAR;
    v_utm_content VARCHAR;
    v_utm_medium_last VARCHAR;
    v_utm_campaign_last VARCHAR;
    v_utm_term_last VARCHAR;
    v_utm_content_last VARCHAR;
    v_req_sum NUMERIC;
    v_req_term VARCHAR;
    v_lastname VARCHAR;
    v_firstname VARCHAR;
    v_patronimic VARCHAR;
    v_birthday DATE;
    v_phone_mobile VARCHAR;
    v_email VARCHAR;
    v_snils VARCHAR;
    v_inn VARCHAR;
    v_inn_result VARCHAR;
    v_uprid_result VARCHAR;
    v_uprid_channel VARCHAR;
    v_gender VARCHAR;
    v_pass_serial VARCHAR;
    v_pass_number VARCHAR;
    v_pass_issuer VARCHAR;
    v_pass_issuer_code VARCHAR;
    v_pass_issue_date DATE;
    v_birthplace VARCHAR;
    v_reg_region VARCHAR;
    v_reg_region_key VARCHAR;
    v_reg_city VARCHAR;
    v_reg_city_key VARCHAR;
    v_reg_settlement VARCHAR;
    v_reg_settlement_key VARCHAR;
    v_reg_street VARCHAR;
    v_reg_street_key VARCHAR;
    v_reg_house VARCHAR;
    v_reg_housing VARCHAR;
    v_reg_building VARCHAR;
    v_reg_flat VARCHAR;
    v_family_status VARCHAR;
    v_emloyment_type VARCHAR;
    v_organization_type VARCHAR;
    v_company_occupation VARCHAR;
    v_position_type VARCHAR;
    v_last_work_term VARCHAR;
    v_monthly_income NUMERIC;
    v_loan_purpose VARCHAR;
    v_litigation BOOLEAN;
    v_bankruptcy BOOLEAN;
    v_card_mask VARCHAR;
    v_card_expiration_date VARCHAR;
    v_gateway_name VARCHAR;
    v_card_token VARCHAR;
    v_loanapp_review_id INTEGER;
    v_application_key INTEGER;
    v_reg_region_key_kladr VARCHAR;
    v_reg_city_key_kladr VARCHAR;
    v_reg_settlement_key_kladr VARCHAR;
    v_reg_street_key_kladr VARCHAR;
    v_process_key INTEGER;
    v_result INTEGER;
    v_result_str VARCHAR;
    v_esia_flag INTEGER;
    v_device_type VARCHAR;
    v_client_ip VARCHAR;
    v_device_system VARCHAR;
    v_browser VARCHAR;
    v_browser_version VARCHAR;
    v_cession_of_claims_agreed BOOLEAN;
    v_additional_income NUMERIC;
    v_full_identification_result VARCHAR;
    v_reg_address_full VARCHAR;
    v_vcid VARCHAR;
    v_clicked_from VARCHAR;
    v_juicy_session_id VARCHAR;
    v_business_key VARCHAR;
    v_context VARCHAR; -- Для логирования контекста ошибки
BEGIN
    -- Инициализация выходных параметров
    result = 1;
    result_str = 'OK';
    response = '{}';

    -- Парсинг входного JSON
    BEGIN
        v_json = _request::JSONB;
    EXCEPTION WHEN OTHERS THEN
        result = -1;
        result_str = 'Ошибка парсинга JSON: ' || SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка парсинга JSON в parse_request_for_loanapp_review_5', 
            'parse_request_for_loanapp_review_5', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                '_method', _method,
                '_request', _request
            ), 
            v_context
        );
        response = jsonb_build_object(
            'error', 'Ошибка парсинга JSON: ' || SQLERRM
        )::VARCHAR;
        RETURN;
    END;

    -- Извлечение данных из JSON с учетом NULL для отсутствующих нод и сохранением пустых строк
    v_business_key = CASE WHEN v_json ? 'business-key' THEN v_json->>'business-key' ELSE NULL END;
    v_source_id = CASE WHEN v_json ? 'source_id' THEN v_json->>'source_id' ELSE NULL END;
    v_wm_id = CASE WHEN v_json ? 'wm_id' THEN v_json->>'wm_id' ELSE NULL END;
    v_click_id = CASE WHEN v_json ? 'click_id' THEN v_json->>'click_id' ELSE NULL END;
    v_offer_id = CASE WHEN v_json ? 'offer_id' THEN v_json->>'offer_id' ELSE NULL END;
    v_source_id_last = CASE WHEN v_json ? 'source_id_last' THEN v_json->>'source_id_last' ELSE NULL END;
    v_wm_id_last = CASE WHEN v_json ? 'wm_id_last' THEN v_json->>'wm_id_last' ELSE NULL END;
    v_click_id_last = CASE WHEN v_json ? 'click_id_last' THEN v_json->>'click_id_last' ELSE NULL END;
    v_offer_id_last = CASE WHEN v_json ? 'offer_id_last' THEN v_json->>'offer_id_last' ELSE NULL END;
    v_utm_medium = CASE WHEN v_json ? 'utm_medium' THEN v_json->>'utm_medium' ELSE NULL END;
    v_utm_campaign = CASE WHEN v_json ? 'utm_campaign' THEN v_json->>'utm_campaign' ELSE NULL END;
    v_utm_term = CASE WHEN v_json ? 'utm_term' THEN v_json->>'utm_term' ELSE NULL END;
    v_utm_content = CASE WHEN v_json ? 'utm_content' THEN v_json->>'utm_content' ELSE NULL END;
    v_utm_medium_last = CASE WHEN v_json ? 'utm_medium_last' THEN v_json->>'utm_medium_last' ELSE NULL END;
    v_utm_campaign_last = CASE WHEN v_json ? 'utm_campaign_last' THEN v_json->>'utm_campaign_last' ELSE NULL END;
    v_utm_term_last = CASE WHEN v_json ? 'utm_term_last' THEN v_json->>'utm_term_last' ELSE NULL END;
    v_utm_content_last = CASE WHEN v_json ? 'utm_content_last' THEN v_json->>'utm_content_last' ELSE NULL END;
    v_req_sum = CASE WHEN v_json ? 'req_sum' THEN NULLIF(v_json->>'req_sum', '')::NUMERIC ELSE NULL END;
    v_req_term = CASE WHEN v_json ? 'req_term' THEN v_json->>'req_term' ELSE NULL END;
    v_lastname = CASE WHEN v_json ? 'lastname' THEN v_json->>'lastname' ELSE NULL END;
    v_firstname = CASE WHEN v_json ? 'firstname' THEN v_json->>'firstname' ELSE NULL END;
    v_patronimic = CASE WHEN v_json ? 'patronimic' THEN v_json->>'patronimic' ELSE NULL END;
    v_birthday = CASE WHEN v_json ? 'birthday' THEN NULLIF(v_json->>'birthday', '')::DATE ELSE NULL END;
    v_phone_mobile = CASE WHEN v_json ? 'phone_mobile' THEN v_json->>'phone_mobile' ELSE NULL END;
    v_email = CASE WHEN v_json ? 'email' THEN v_json->>'email' ELSE NULL END;
    v_snils = CASE WHEN v_json ? 'snils' THEN v_json->>'snils' ELSE NULL END;
    v_inn = CASE WHEN v_json ? 'inn' THEN v_json->>'inn' ELSE NULL END;
    v_inn_result = CASE WHEN v_json ? 'inn_result' THEN v_json->>'inn_result' ELSE NULL END;
    v_uprid_result = CASE WHEN v_json ? 'uprid_result' THEN v_json->>'uprid_result' ELSE NULL END;
    v_uprid_channel = CASE WHEN v_json ? 'uprid_channel' THEN v_json->>'uprid_channel' ELSE NULL END;
    v_gender = CASE WHEN v_json ? 'gender' THEN v_json->>'gender' ELSE NULL END;
    v_pass_serial = CASE WHEN v_json ? 'pass_serial' THEN v_json->>'pass_serial' ELSE NULL END;
    v_pass_number = CASE WHEN v_json ? 'pass_number' THEN v_json->>'pass_number' ELSE NULL END;
    v_pass_issuer = CASE WHEN v_json ? 'pass_issuer' THEN v_json->>'pass_issuer' ELSE NULL END;
    v_pass_issuer_code = CASE WHEN v_json ? 'pass_issuer_code' THEN v_json->>'pass_issuer_code' ELSE NULL END;
    v_pass_issue_date = CASE WHEN v_json ? 'pass_issue_date' THEN NULLIF(v_json->>'pass_issue_date', '')::DATE ELSE NULL END;
    v_birthplace = CASE WHEN v_json ? 'birthplace' THEN v_json->>'birthplace' ELSE NULL END;
    v_reg_address_full = CASE WHEN v_json ? 'reg_address_full' THEN v_json->>'reg_address_full' ELSE NULL END;
    v_reg_region = CASE WHEN v_json ? 'reg_region' THEN v_json->>'reg_region' ELSE NULL END;
    v_reg_region_key = CASE WHEN v_json ? 'reg_region_key' THEN v_json->>'reg_region_key' ELSE NULL END;
    v_reg_city = CASE WHEN v_json ? 'reg_city' THEN v_json->>'reg_city' ELSE NULL END;
    v_reg_city_key = CASE WHEN v_json ? 'reg_city_key' THEN v_json->>'reg_city_key' ELSE NULL END;
    v_reg_settlement = CASE WHEN v_json ? 'reg_settlement' THEN v_json->>'reg_settlement' ELSE NULL END;
    v_reg_settlement_key = CASE WHEN v_json ? 'reg_settlement_key' THEN v_json->>'reg_settlement_key' ELSE NULL END;
    v_reg_street = CASE WHEN v_json ? 'reg_street' THEN v_json->>'reg_street' ELSE NULL END;
    v_reg_street_key = CASE WHEN v_json ? 'reg_street_key' THEN v_json->>'reg_street_key' ELSE NULL END;
    v_reg_house = CASE WHEN v_json ? 'reg_house' THEN v_json->>'reg_house' ELSE NULL END;
    v_reg_housing = CASE WHEN v_json ? 'reg_housing' THEN v_json->>'reg_housing' ELSE NULL END;
    v_reg_building = CASE WHEN v_json ? 'reg_building' THEN v_json->>'reg_building' ELSE NULL END;
    v_reg_flat = CASE WHEN v_json ? 'reg_flat' THEN v_json->>'reg_flat' ELSE NULL END;
    v_family_status = CASE WHEN v_json ? 'family_status' THEN v_json->>'family_status' ELSE NULL END;
    v_emloyment_type = CASE WHEN v_json ? 'emloyment_type' THEN v_json->>'emloyment_type' ELSE NULL END;
    v_organization_type = CASE WHEN v_json ? 'organization_type' THEN v_json->>'organization_type' ELSE NULL END;
    v_company_occupation = CASE WHEN v_json ? 'company_occupation' THEN v_json->>'company_occupation' ELSE NULL END;
    v_position_type = CASE WHEN v_json ? 'position_type' THEN v_json->>'position_type' ELSE NULL END;
    v_last_work_term = CASE WHEN v_json ? 'last_work_term' THEN v_json->>'last_work_term' ELSE NULL END;
    v_monthly_income = CASE WHEN v_json ? 'monthly_income' THEN NULLIF(v_json->>'monthly_income', '')::NUMERIC ELSE NULL END;
    v_loan_purpose = CASE WHEN v_json ? 'loan_purpose' THEN v_json->>'loan_purpose' ELSE NULL END;
    v_litigation = CASE WHEN v_json ? 'litigation' THEN NULLIF(v_json->>'litigation', '')::BOOLEAN ELSE NULL END;
    v_litigation = COALESCE(v_litigation, FALSE);
    v_bankruptcy = CASE WHEN v_json ? 'bankruptcy' THEN NULLIF(v_json->>'bankruptcy', '')::BOOLEAN ELSE NULL END;
    v_bankruptcy = COALESCE(v_bankruptcy, FALSE);
    v_card_mask = CASE WHEN v_json ? 'card_mask' THEN v_json->>'card_mask' ELSE NULL END;
    v_card_expiration_date = CASE WHEN v_json ? 'card_expiration_date' THEN v_json->>'card_expiration_date' ELSE NULL END;
    v_gateway_name = CASE WHEN v_json ? 'gateway_name' THEN v_json->>'gateway_name' ELSE NULL END;
    v_card_token = CASE WHEN v_json ? 'card_token' THEN v_json->>'card_token' ELSE NULL END;
    v_esia_flag = CASE WHEN v_json ? 'esia_flag' THEN NULLIF(v_json->>'esia_flag', '')::INTEGER ELSE NULL END;
    v_device_type = CASE WHEN v_json ? 'device_type' THEN v_json->>'device_type' ELSE NULL END;
    v_client_ip = CASE WHEN v_json ? 'client_ip' THEN v_json->>'client_ip' ELSE NULL END;
    v_device_system = CASE WHEN v_json ? 'device_system' THEN v_json->>'device_system' ELSE NULL END;
    v_browser = CASE WHEN v_json ? 'browser' THEN v_json->>'browser' ELSE NULL END;
    v_browser_version = CASE WHEN v_json ? 'browser_version' THEN v_json->>'browser_version' ELSE NULL END;
    v_cession_of_claims_agreed = CASE WHEN v_json ? 'cession_of_claims_agreed' THEN NULLIF(v_json->>'cession_of_claims_agreed', '')::BOOLEAN ELSE NULL END;
    v_cession_of_claims_agreed = COALESCE(v_cession_of_claims_agreed, FALSE);
    v_additional_income = CASE WHEN v_json ? 'additional_income' THEN NULLIF(v_json->>'additional_income', '')::NUMERIC ELSE NULL END;
    v_full_identification_result = CASE WHEN v_json ? 'full_identification_result' THEN v_json->>'full_identification_result' ELSE NULL END;
    v_vcid = CASE WHEN v_json ? 'vcid' THEN v_json->>'vcid' ELSE NULL END;
    v_clicked_from = CASE WHEN v_json ? 'clicked_from' THEN v_json->>'clicked_from' ELSE NULL END;
    v_juicy_session_id = CASE WHEN v_json ? 'juicy_session_id' THEN v_json->>'juicy_session_id' ELSE NULL END;

    -- Извлечение вложенного объекта agreemets_part2_md5
    v_agreemets_part2_md5 = v_json->'agreemets_part2_md5';
    v_nbki_md5 = CASE WHEN v_agreemets_part2_md5 ? 'nbki_md5' THEN v_agreemets_part2_md5->>'nbki_md5' ELSE NULL END;
    v_equifax_md5 = CASE WHEN v_agreemets_part2_md5 ? 'equifax_md5' THEN v_agreemets_part2_md5->>'equifax_md5' ELSE NULL END;
    v_rus_standart_md5 = CASE WHEN v_agreemets_part2_md5 ? 'rus_standart_md5' THEN v_agreemets_part2_md5->>'rus_standart_md5' ELSE NULL END;
    v_service_agreement_md5 = CASE WHEN v_agreemets_part2_md5 ? 'service_agreement_md5' THEN v_agreemets_part2_md5->>'service_agreement_md5' ELSE NULL END;

    -- Проверка обязательных полей
    IF v_lastname IS NULL OR v_req_sum IS NULL
        OR v_firstname IS NULL OR v_pass_serial IS NULL
        OR v_pass_number IS NULL THEN
        result = -1;
        result_str = 'Ошибка: обязательные поля не заполнены';
        response = jsonb_build_object(
            'error', 'Обязательные поля (lastname, req_sum, firstname, pass_serial, pass_number) не заполнены'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Заглушка для тестовых паспортов
    IF db_type() <> 'WORK' AND LEFT(v_pass_serial, 2) = '98' THEN
        result = -1;
        result_str = 'Заглушка';
        response = jsonb_build_object(
            'error', 'Заглушка для тестовых паспортов'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Обработка кода подразделения паспорта
    IF v_pass_issuer_code IS NOT NULL AND v_pass_issuer_code !~* '^\d+$' THEN
        v_pass_issuer_code = REPLACE(v_pass_issuer_code, ' ', '');
        v_pass_issuer_code = REPLACE(v_pass_issuer_code, '-', '');
        v_pass_issuer_code = REPLACE(v_pass_issuer_code, '_', '');

        IF CHAR_LENGTH(v_pass_issuer_code) = 6 THEN
            v_pass_issuer_code = LEFT(v_pass_issuer_code, 3) || '-' || RIGHT(v_pass_issuer_code, 3);
        END IF;
    END IF;

    -- Обработка номера телефона
    IF v_phone_mobile IS NOT NULL AND LENGTH(v_phone_mobile) = 10 THEN
        v_phone_mobile = '+7' || v_phone_mobile;
    END IF;

    -- Разбор адреса, если регион указан
    IF v_reg_region IS NOT NULL THEN
        SELECT t.region_code, t.city_code, t.settlement_code, t.street_code
        FROM online_back.explode_address2(
            v_reg_region,
            v_reg_city,
            v_reg_settlement,
            v_reg_street,
            v_reg_region_key,
            v_reg_city_key,
            v_reg_settlement_key,
            v_reg_street_key,
            v_reg_house,
            v_reg_building,
            v_reg_housing,
            v_reg_flat) AS t
        INTO v_reg_region_key_kladr, v_reg_city_key_kladr, v_reg_settlement_key_kladr, v_reg_street_key_kladr;

        IF v_reg_region_key_kladr IS NULL THEN
            SELECT t.region_code, t.city_code, t.settlement_code, t.street_code
            FROM online_back.explode_address3(
                v_reg_region,
                v_reg_city,
                v_reg_settlement,
                v_reg_street,
                v_reg_region_key,
                v_reg_city_key,
                v_reg_settlement_key,
                v_reg_street_key,
                v_reg_house,
                v_reg_building,
                v_reg_housing,
                v_reg_flat) AS t
            INTO v_reg_region_key_kladr, v_reg_city_key_kladr, v_reg_settlement_key_kladr, v_reg_street_key_kladr;
        END IF;
    END IF;

    -- Добавление улицы в справочник KLADR, если нужно
    IF v_reg_street_key IS NOT NULL AND v_reg_street_key_kladr IS NULL AND (
        v_reg_settlement_key_kladr IS NOT NULL OR v_reg_city_key_kladr IS NOT NULL OR v_reg_region_key_kladr IS NOT NULL
    ) THEN
        -- Пытаемся добавить в справочник
        SELECT f.kladr_key
        FROM kladr.add_or_find_kladr_street(v_reg_street, '', v_reg_street_key::VARCHAR,
            COALESCE(v_reg_settlement_key_kladr, v_reg_city_key_kladr, v_reg_region_key_kladr)::VARCHAR) AS f
        INTO v_reg_street_key_kladr;
    END IF;

    -- Вставка данных в таблицу loanapp_review
    INSERT INTO online_processes.loanapp_review (
      business_key,
      source_id,
      wm_id,
      click_id,
      offer_id,
      source_id_last,
      wm_id_last,
      click_id_last,
      offer_id_last,
      utm_medium,
      utm_campaign,
      utm_term,
      utm_content,
      utm_medium_last,
      utm_campaign_last,
      utm_term_last,
      utm_content_last,
      req_sum,
      req_term,
      lastname,
      firstname,
      patronimic,
      birthday,
      phone_mobile,
      e_mail,
      snils,
      inn,
      inn_result,
      uprid_result,
      uprid_channel,
      gender,
      pass_serial,
      pass_number,
      pass_issuer,
      pass_issuer_code,
      pass_issue_date,
      birthplace,
      reg_region,
      reg_region_key,
      reg_region_key_kladr,
      reg_city,
      reg_city_key,
      reg_city_key_kladr,
      reg_settlement,
      reg_settlement_key,
      reg_settlement_key_kladr,
      reg_street,
      reg_street_key,
      reg_street_key_kladr,
      reg_house,
      reg_housing,
      reg_building,
      reg_flat,
      family_status,
      emloyment_type,
      organization_type,
      company_occupation,
      position_type,
      last_work_term,
      monthly_income,
      loan_purpose,
      litigation,
      bankruptcy,
      card_mask,
      card_expiration_date,
      gateway_name,
      card_token,
      esia_flag,
      device_type,
      client_ip,
      device_system,
      browser,
      browser_version,
      cession_of_claims_agreed,
      additional_income,
      full_identification_result,
      reg_address_full,
      nbki_md5,
      equifax_md5,
      rus_standart_md5,
      service_agreement_md5,
      vcid,
      clicked_from,
      juicy_session_id
    )
    VALUES (
      v_business_key,
      v_source_id,
      v_wm_id,
      v_click_id,
      v_offer_id,
      v_source_id_last,
      v_wm_id_last,
      v_click_id_last,
      v_offer_id_last,
      v_utm_medium,
      v_utm_campaign,
      v_utm_term,
      v_utm_content,
      v_utm_medium_last,
      v_utm_campaign_last,
      v_utm_term_last,
      v_utm_content_last,
      v_req_sum,
      v_req_term,
      UPPER(BTRIM(COALESCE(v_lastname, ''))),
      UPPER(BTRIM(COALESCE(v_firstname, ''))),
      UPPER(BTRIM(COALESCE(v_patronimic, ''))),
      v_birthday,
      v_phone_mobile,
      v_email,
      v_snils,
      v_inn,
      v_inn_result,
      v_uprid_result,
      v_uprid_channel,
      v_gender,
      v_pass_serial,
      v_pass_number,
      UPPER(COALESCE(v_pass_issuer, '')),
      v_pass_issuer_code,
      v_pass_issue_date,
      UPPER(COALESCE(v_birthplace, '')),
      v_reg_region,
      v_reg_region_key,
      v_reg_region_key_kladr,
      v_reg_city,
      v_reg_city_key,
      v_reg_city_key_kladr,
      v_reg_settlement,
      v_reg_settlement_key,
      v_reg_settlement_key_kladr,
      v_reg_street,
      v_reg_street_key,
      v_reg_street_key_kladr,
      v_reg_house,
      v_reg_housing,
      v_reg_building,
      v_reg_flat,
      v_family_status,
      v_emloyment_type,
      v_organization_type,
      v_company_occupation,
      v_position_type,
      v_last_work_term,
      v_monthly_income,
      v_loan_purpose,
      v_litigation,
      v_bankruptcy,
      v_card_mask,
      v_card_expiration_date,
      v_gateway_name,
      v_card_token,
      v_esia_flag,
      v_device_type,
      v_client_ip,
      v_device_system,
      v_browser,
      v_browser_version,
      v_cession_of_claims_agreed,
      v_additional_income,
      UPPER(COALESCE(v_full_identification_result, '')),
      v_reg_address_full,
      v_nbki_md5,
      v_equifax_md5,
      v_rus_standart_md5,
      v_service_agreement_md5,
      v_vcid,
      v_clicked_from,
      v_juicy_session_id
    )
    RETURNING loanapp_review_id
    INTO v_loanapp_review_id;

    -- Создание заявки в loan_issue.application
    SELECT c.result, c.result_str, c.proc_key, c.application_key
    FROM eis_processes.convert_to_li_app_5(v_loanapp_review_id, v_business_key) AS c
    INTO v_result, v_result_str, v_process_key, v_application_key;

    -- Проверка результата конвертации
    IF v_result = -1 THEN
        result = -1;
        result_str = v_result_str;
        response = jsonb_build_object(
            'error', v_result_str
        )::VARCHAR;
        
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка конвертации в parse_request_for_loanapp_review_5: ' || v_result_str, 
            'parse_request_for_loanapp_review_5', 
            jsonb_build_object(
                '_method', _method,
                'business_key', v_business_key
            ), 
            v_context
        );
        RETURN;
    END IF;

    -- Создание объекта рассмотрения заявки
    INSERT INTO online_processes.app_loanapp_review (
      loanapp_review_id,
      application_key,
      process_key
    )
    VALUES (
      v_loanapp_review_id,
      v_application_key,
      v_process_key
    );

    -- Вставка данных в application_uprid
    INSERT INTO loan_issue.application_uprid (
      application_key, 
      ext_object_type, 
      ext_object_key, 
      inn_status, 
      inn, 
      uprid_status
    )
    VALUES (
      v_application_key, 
      'Bankiru', 
      v_application_key, 
      UPPER(COALESCE(v_inn_result, '')),
      v_inn, 
      UPPER(COALESCE(v_uprid_result, ''))
    );

    result = 1;
    result_str = 'Ok';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка неожиданных ошибок
    result = -1;
    result_str = SQLERRM;
    GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
    PERFORM api.add_log(
        'ERROR', 
        'Неожиданная ошибка в parse_request_for_loanapp_review_5', 
        'parse_request_for_loanapp_review_5', 
        jsonb_build_object(
            'sql_error', SQLERRM,
            '_method', _method,
            '_request', _request
        ), 
        v_context
    );
    response = jsonb_build_object(
        'error', 'Неожиданная ошибка: ' || SQLERRM
    )::VARCHAR;
    RETURN;
END;
$function$
;

-- DROP FUNCTION api.parse_request_for_loanapp_review_leasing(in varchar, in varchar, out int4, out varchar, out varchar);

CREATE OR REPLACE FUNCTION api.parse_request_for_loanapp_review_leasing(_method character varying, _request character varying, OUT result integer, OUT result_str character varying, OUT response character varying)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
/*<description>
	Рассмотрение кредитной заявки Лизинг, принимающий JSON и возвращающий JSON
</description>
<history_list>
    <item><date_m>17.09.2025</date_m><task_n>55444014</task_n><author>Крупская И.Е.</author></item>
    <item><date_m>26.09.2025</date_m><task_n></task_n><author>xtetis</author></item>
</history_list>*/
    v_json JSONB; -- Переменная для хранения входного JSON
    v_agreemets_part2_md5 JSONB; -- Вложенный объект для согласий
    v_nbki_md5 VARCHAR;
    v_equifax_md5 VARCHAR;
    v_rus_standart_md5 VARCHAR;
    v_service_agreement_md5 VARCHAR;
    v_source_id VARCHAR;
    v_wm_id VARCHAR;
    v_click_id VARCHAR;
    v_offer_id VARCHAR;
    v_source_id_last VARCHAR;
    v_wm_id_last VARCHAR;
    v_click_id_last VARCHAR;
    v_offer_id_last VARCHAR;
    v_utm_medium VARCHAR;
    v_utm_campaign VARCHAR;
    v_utm_term VARCHAR;
    v_utm_content VARCHAR;
    v_utm_medium_last VARCHAR;
    v_utm_campaign_last VARCHAR;
    v_utm_term_last VARCHAR;
    v_utm_content_last VARCHAR;
    v_req_sum NUMERIC;
    v_req_term VARCHAR;
    v_lastname VARCHAR;
    v_firstname VARCHAR;
    v_patronimic VARCHAR;
    v_birthday DATE;
    v_phone_mobile VARCHAR;
    v_email VARCHAR;
    v_snils VARCHAR;
    v_inn VARCHAR;
    v_inn_result VARCHAR;
    v_uprid_result VARCHAR;
  	v_uprid_channel VARCHAR;
    v_gender VARCHAR;
    v_pass_serial VARCHAR;
    v_pass_number VARCHAR;
    v_pass_issuer VARCHAR;
    v_pass_issuer_code VARCHAR;
    v_pass_issue_date DATE;
    v_birthplace VARCHAR;
    v_reg_region VARCHAR;
    v_reg_region_key VARCHAR;
    v_reg_city VARCHAR;
    v_reg_city_key VARCHAR;
    v_reg_settlement VARCHAR;
    v_reg_settlement_key VARCHAR;
    v_reg_street VARCHAR;
    v_reg_street_key VARCHAR;
    v_reg_house VARCHAR;
    v_reg_housing VARCHAR;
    v_reg_building VARCHAR;
    v_reg_flat VARCHAR;
    v_family_status VARCHAR;
    v_emloyment_type VARCHAR;
    v_organization_type VARCHAR;
    v_company_occupation VARCHAR;
    v_position_type VARCHAR;
    v_last_work_term VARCHAR;
    v_monthly_income NUMERIC;
    v_loan_purpose VARCHAR;
    v_litigation BOOLEAN;
    v_bankruptcy BOOLEAN;
    v_card_mask VARCHAR;
    v_card_expiration_date VARCHAR;
    v_gateway_name VARCHAR;
    v_card_token VARCHAR;
    v_loanapp_review_id INTEGER;
    v_application_key INTEGER;
    v_reg_region_key_kladr VARCHAR;
    v_reg_city_key_kladr VARCHAR;
    v_reg_settlement_key_kladr VARCHAR;
    v_reg_street_key_kladr VARCHAR;
    v_process_key INTEGER;
    v_result INTEGER;
    v_result_str VARCHAR;
    v_esia_flag INTEGER;
    v_device_type VARCHAR;
    v_client_ip VARCHAR;
    v_device_system VARCHAR;
    v_browser VARCHAR;
    v_browser_version VARCHAR;
    v_cession_of_claims_agreed BOOLEAN;
    v_additional_income NUMERIC;
    v_full_identification_result VARCHAR;
    v_reg_address_full VARCHAR;
    v_vcid VARCHAR;
    v_clicked_from VARCHAR;
    v_juicy_session_id VARCHAR;
    v_business_key VARCHAR;
    v_context VARCHAR; -- Для логирования контекста ошибки
BEGIN
    -- Инициализация выходных параметров
    result = 1;
    result_str = 'OK';
    response = '{}';

    -- Парсинг входного JSON
    BEGIN
        v_json = _request::JSONB;
    EXCEPTION WHEN OTHERS THEN
        result = -1;
        result_str = 'Ошибка парсинга JSON: ' || SQLERRM;
        GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка парсинга JSON в parse_request_for_loanapp_review_leasing', 
            'parse_request_for_loanapp_review_leasing', 
            jsonb_build_object(
                'sql_error', SQLERRM,
                '_method', _method,
                '_request', _request
            ), 
            v_context
        );
        response = jsonb_build_object(
            'error', 'Ошибка парсинга JSON: ' || SQLERRM
        )::VARCHAR;
        RETURN;
    END;

    -- Извлечение данных из JSON с учетом NULL для отсутствующих нод и сохранением пустых строк
    v_business_key = CASE WHEN v_json ? 'business-key' THEN v_json->>'business-key' ELSE NULL END;
    v_source_id = CASE WHEN v_json ? 'source_id' THEN v_json->>'source_id' ELSE NULL END;
    v_wm_id = CASE WHEN v_json ? 'wm_id' THEN v_json->>'wm_id' ELSE NULL END;
    v_click_id = CASE WHEN v_json ? 'click_id' THEN v_json->>'click_id' ELSE NULL END;
    v_offer_id = CASE WHEN v_json ? 'offer_id' THEN v_json->>'offer_id' ELSE NULL END;
    v_source_id_last = CASE WHEN v_json ? 'source_id_last' THEN v_json->>'source_id_last' ELSE NULL END;
    v_wm_id_last = CASE WHEN v_json ? 'wm_id_last' THEN v_json->>'wm_id_last' ELSE NULL END;
    v_click_id_last = CASE WHEN v_json ? 'click_id_last' THEN v_json->>'click_id_last' ELSE NULL END;
    v_offer_id_last = CASE WHEN v_json ? 'offer_id_last' THEN v_json->>'offer_id_last' ELSE NULL END;
    v_utm_medium = CASE WHEN v_json ? 'utm_medium' THEN v_json->>'utm_medium' ELSE NULL END;
    v_utm_campaign = CASE WHEN v_json ? 'utm_campaign' THEN v_json->>'utm_campaign' ELSE NULL END;
    v_utm_term = CASE WHEN v_json ? 'utm_term' THEN v_json->>'utm_term' ELSE NULL END;
    v_utm_content = CASE WHEN v_json ? 'utm_content' THEN v_json->>'utm_content' ELSE NULL END;
    v_utm_medium_last = CASE WHEN v_json ? 'utm_medium_last' THEN v_json->>'utm_medium_last' ELSE NULL END;
    v_utm_campaign_last = CASE WHEN v_json ? 'utm_campaign_last' THEN v_json->>'utm_campaign_last' ELSE NULL END;
    v_utm_term_last = CASE WHEN v_json ? 'utm_term_last' THEN v_json->>'utm_term_last' ELSE NULL END;
    v_utm_content_last = CASE WHEN v_json ? 'utm_content_last' THEN v_json->>'utm_content_last' ELSE NULL END;
    v_req_sum = CASE WHEN v_json ? 'req_sum' THEN NULLIF(v_json->>'req_sum', '')::NUMERIC ELSE NULL END;
    v_req_term = CASE WHEN v_json ? 'req_term' THEN v_json->>'req_term' ELSE NULL END;
    v_lastname = CASE WHEN v_json ? 'lastname' THEN v_json->>'lastname' ELSE NULL END;
    v_firstname = CASE WHEN v_json ? 'firstname' THEN v_json->>'firstname' ELSE NULL END;
    v_patronimic = CASE WHEN v_json ? 'patronimic' THEN v_json->>'patronimic' ELSE NULL END;
    v_birthday = CASE WHEN v_json ? 'birthday' THEN NULLIF(v_json->>'birthday', '')::DATE ELSE NULL END;
    v_phone_mobile = CASE WHEN v_json ? 'phone_mobile' THEN v_json->>'phone_mobile' ELSE NULL END;
    v_email = CASE WHEN v_json ? 'email' THEN v_json->>'email' ELSE NULL END;
    v_snils = CASE WHEN v_json ? 'snils' THEN v_json->>'snils' ELSE NULL END;
    v_inn = CASE WHEN v_json ? 'inn' THEN v_json->>'inn' ELSE NULL END;
    v_inn_result = CASE WHEN v_json ? 'inn_result' THEN v_json->>'inn_result' ELSE NULL END;
    v_uprid_result = CASE WHEN v_json ? 'uprid_result' THEN v_json->>'uprid_result' ELSE NULL END;
    v_uprid_channel = CASE WHEN v_json ? 'uprid_channel' THEN v_json->>'uprid_channel' ELSE NULL END;
    v_gender = CASE WHEN v_json ? 'gender' THEN v_json->>'gender' ELSE NULL END;
    v_pass_serial = CASE WHEN v_json ? 'pass_serial' THEN v_json->>'pass_serial' ELSE NULL END;
    v_pass_number = CASE WHEN v_json ? 'pass_number' THEN v_json->>'pass_number' ELSE NULL END;
    v_pass_issuer = CASE WHEN v_json ? 'pass_issuer' THEN v_json->>'pass_issuer' ELSE NULL END;
    v_pass_issuer_code = CASE WHEN v_json ? 'pass_issuer_code' THEN v_json->>'pass_issuer_code' ELSE NULL END;
    v_pass_issue_date = CASE WHEN v_json ? 'pass_issue_date' THEN NULLIF(v_json->>'pass_issue_date', '')::DATE ELSE NULL END;
    v_birthplace = CASE WHEN v_json ? 'birthplace' THEN v_json->>'birthplace' ELSE NULL END;
    v_reg_address_full = CASE WHEN v_json ? 'reg_address_full' THEN v_json->>'reg_address_full' ELSE NULL END;
    v_reg_region = CASE WHEN v_json ? 'reg_region' THEN v_json->>'reg_region' ELSE NULL END;
    v_reg_region_key = CASE WHEN v_json ? 'reg_region_key' THEN v_json->>'reg_region_key' ELSE NULL END;
    v_reg_city = CASE WHEN v_json ? 'reg_city' THEN v_json->>'reg_city' ELSE NULL END;
    v_reg_city_key = CASE WHEN v_json ? 'reg_city_key' THEN v_json->>'reg_city_key' ELSE NULL END;
    v_reg_settlement = CASE WHEN v_json ? 'reg_settlement' THEN v_json->>'reg_settlement' ELSE NULL END;
    v_reg_settlement_key = CASE WHEN v_json ? 'reg_settlement_key' THEN v_json->>'reg_settlement_key' ELSE NULL END;
    v_reg_street = CASE WHEN v_json ? 'reg_street' THEN v_json->>'reg_street' ELSE NULL END;
    v_reg_street_key = CASE WHEN v_json ? 'reg_street_key' THEN v_json->>'reg_street_key' ELSE NULL END;
    v_reg_house = CASE WHEN v_json ? 'reg_house' THEN v_json->>'reg_house' ELSE NULL END;
    v_reg_housing = CASE WHEN v_json ? 'reg_housing' THEN v_json->>'reg_housing' ELSE NULL END;
    v_reg_building = CASE WHEN v_json ? 'reg_building' THEN v_json->>'reg_building' ELSE NULL END;
    v_reg_flat = CASE WHEN v_json ? 'reg_flat' THEN v_json->>'reg_flat' ELSE NULL END;
    v_family_status = CASE WHEN v_json ? 'family_status' THEN v_json->>'family_status' ELSE NULL END;
    v_emloyment_type = CASE WHEN v_json ? 'emloyment_type' THEN v_json->>'emloyment_type' ELSE NULL END;
    v_organization_type = CASE WHEN v_json ? 'organization_type' THEN v_json->>'organization_type' ELSE NULL END;
    v_company_occupation = CASE WHEN v_json ? 'company_occupation' THEN v_json->>'company_occupation' ELSE NULL END;
    v_position_type = CASE WHEN v_json ? 'position_type' THEN v_json->>'position_type' ELSE NULL END;
    v_last_work_term = CASE WHEN v_json ? 'last_work_term' THEN v_json->>'last_work_term' ELSE NULL END;
    v_monthly_income = CASE WHEN v_json ? 'monthly_income' THEN NULLIF(v_json->>'monthly_income', '')::NUMERIC ELSE NULL END;
    v_loan_purpose = CASE WHEN v_json ? 'loan_purpose' THEN v_json->>'loan_purpose' ELSE NULL END;
    v_litigation = CASE WHEN v_json ? 'litigation' THEN NULLIF(v_json->>'litigation', '')::BOOLEAN ELSE NULL END;
    v_litigation = COALESCE(v_litigation, FALSE);
    v_bankruptcy = CASE WHEN v_json ? 'bankruptcy' THEN NULLIF(v_json->>'bankruptcy', '')::BOOLEAN ELSE NULL END;
    v_bankruptcy = COALESCE(v_bankruptcy, FALSE);
    v_card_mask = CASE WHEN v_json ? 'card_mask' THEN v_json->>'card_mask' ELSE NULL END;
    v_card_expiration_date = CASE WHEN v_json ? 'card_expiration_date' THEN v_json->>'card_expiration_date' ELSE NULL END;
    v_gateway_name = CASE WHEN v_json ? 'gateway_name' THEN v_json->>'gateway_name' ELSE NULL END;
    v_card_token = CASE WHEN v_json ? 'card_token' THEN v_json->>'card_token' ELSE NULL END;
    v_esia_flag = CASE WHEN v_json ? 'esia_flag' THEN NULLIF(v_json->>'esia_flag', '')::INTEGER ELSE NULL END;
    v_device_type = CASE WHEN v_json ? 'device_type' THEN v_json->>'device_type' ELSE NULL END;
    v_client_ip = CASE WHEN v_json ? 'client_ip' THEN v_json->>'client_ip' ELSE NULL END;
    v_device_system = CASE WHEN v_json ? 'device_system' THEN v_json->>'device_system' ELSE NULL END;
    v_browser = CASE WHEN v_json ? 'browser' THEN v_json->>'browser' ELSE NULL END;
    v_browser_version = CASE WHEN v_json ? 'browser_version' THEN v_json->>'browser_version' ELSE NULL END;
    v_cession_of_claims_agreed = CASE WHEN v_json ? 'cession_of_claims_agreed' THEN NULLIF(v_json->>'cession_of_claims_agreed', '')::BOOLEAN ELSE NULL END;
    v_cession_of_claims_agreed = COALESCE(v_cession_of_claims_agreed, FALSE);
    v_additional_income = CASE WHEN v_json ? 'additional_income' THEN NULLIF(v_json->>'additional_income', '')::NUMERIC ELSE NULL END;
    v_full_identification_result = CASE WHEN v_json ? 'full_identification_result' THEN v_json->>'full_identification_result' ELSE NULL END;
    v_vcid = CASE WHEN v_json ? 'vcid' THEN v_json->>'vcid' ELSE NULL END;
    v_clicked_from = CASE WHEN v_json ? 'clicked_from' THEN v_json->>'clicked_from' ELSE NULL END;
    v_juicy_session_id = CASE WHEN v_json ? 'juicy_session_id' THEN v_json->>'juicy_session_id' ELSE NULL END;

    -- Извлечение вложенного объекта agreemets_part2_md5
    v_agreemets_part2_md5 = CASE WHEN v_json ? 'agreemets_part2_md5' THEN v_json->'agreemets_part2_md5' ELSE NULL END;
    v_nbki_md5 = CASE WHEN v_agreemets_part2_md5 ? 'nbki_md5' THEN v_agreemets_part2_md5->>'nbki_md5' ELSE NULL END;
    v_equifax_md5 = CASE WHEN v_agreemets_part2_md5 ? 'equifax_md5' THEN v_agreemets_part2_md5->>'equifax_md5' ELSE NULL END;
    v_rus_standart_md5 = CASE WHEN v_agreemets_part2_md5 ? 'rus_standart_md5' THEN v_agreemets_part2_md5->>'rus_standart_md5' ELSE NULL END;
    v_service_agreement_md5 = CASE WHEN v_agreemets_part2_md5 ? 'service_agreement_md5' THEN v_agreemets_part2_md5->>'service_agreement_md5' ELSE NULL END;

    -- Проверка обязательных полей
    IF v_lastname IS NULL OR v_req_sum IS NULL
    	OR v_firstname IS NULL OR v_pass_serial IS NULL
        OR v_pass_number IS NULL THEN
        result = -1;
        result_str = 'Ошибка: обязательные поля не заполнены';
        response = jsonb_build_object(
            'error', 'Обязательные поля (lastname, req_sum, firstname, pass_serial, pass_number) не заполнены'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Заглушка для тестовых паспортов
    IF db_type() <> 'WORK' AND LEFT(v_pass_serial, 2) = '98' THEN
    	result = -1;
        result_str = 'Заглушка';
        response = jsonb_build_object(
            'error', 'Заглушка для тестовых паспортов'
        )::VARCHAR;
        RETURN;
    END IF;

    -- Обработка кода подразделения паспорта
    IF v_pass_issuer_code IS NOT NULL AND v_pass_issuer_code !~* '^\d+$' THEN
    	v_pass_issuer_code = REPLACE(v_pass_issuer_code, ' ', '');
    	v_pass_issuer_code = REPLACE(v_pass_issuer_code, '-', '');
    	v_pass_issuer_code = REPLACE(v_pass_issuer_code, '_', '');

    	IF CHAR_LENGTH(v_pass_issuer_code) = 6 THEN
        	v_pass_issuer_code = LEFT(v_pass_issuer_code, 3) || '-' || RIGHT(v_pass_issuer_code, 3);
        END IF;
   	END IF;

    -- Обработка номера телефона
    IF v_phone_mobile IS NOT NULL AND LENGTH(v_phone_mobile) = 10 THEN
    	v_phone_mobile = '+7' || v_phone_mobile;
    END IF;

    -- Разбор адреса, если регион указан
    IF v_reg_region IS NOT NULL THEN
        SELECT t.region_code, t.city_code, t.settlement_code, t.street_code
        FROM online_back.explode_address2(
            v_reg_region,
            v_reg_city,
            v_reg_settlement,
            v_reg_street,
            v_reg_region_key,
            v_reg_city_key,
            v_reg_settlement_key,
            v_reg_street_key,
            v_reg_house,
            v_reg_building,
            v_reg_housing,
            v_reg_flat) AS t
        INTO v_reg_region_key_kladr, v_reg_city_key_kladr, v_reg_settlement_key_kladr, v_reg_street_key_kladr;

        IF v_reg_region_key_kladr IS NULL THEN
            SELECT t.region_code, t.city_code, t.settlement_code, t.street_code
            FROM online_back.explode_address3(
                v_reg_region,
                v_reg_city,
                v_reg_settlement,
                v_reg_street,
                v_reg_region_key,
                v_reg_city_key,
                v_reg_settlement_key,
                v_reg_street_key,
                v_reg_house,
                v_reg_building,
                v_reg_housing,
                v_reg_flat) AS t
            INTO v_reg_region_key_kladr, v_reg_city_key_kladr, v_reg_settlement_key_kladr, v_reg_street_key_kladr;
        END IF;
    END IF;

    -- Добавление улицы в справочник KLADR, если нужно
    IF v_reg_street_key IS NOT NULL AND v_reg_street_key_kladr IS NULL AND (
    	v_reg_settlement_key_kladr IS NOT NULL OR v_reg_city_key_kladr IS NOT NULL OR v_reg_region_key_kladr IS NOT NULL
    ) THEN
    	-- Пытаемся добавить в справочник
        SELECT f.kladr_key
        FROM kladr.add_or_find_kladr_street(v_reg_street, '', v_reg_street_key::VARCHAR,
        	COALESCE(v_reg_settlement_key_kladr, v_reg_city_key_kladr, v_reg_region_key_kladr)::VARCHAR) AS f
        INTO v_reg_street_key_kladr;
    END IF;

    -- Вставка данных в таблицу loanapp_review_leasing
    INSERT INTO eis_processes.loanapp_review_leasing (
      business_key,
      source_id,
      wm_id,
      click_id,
      offer_id,
      source_id_last,
      wm_id_last,
      click_id_last,
      offer_id_last,
      utm_medium,
      utm_campaign,
      utm_term,
      utm_content,
      utm_medium_last,
      utm_campaign_last,
      utm_term_last,
      utm_content_last,
      req_sum,
      req_term,
      lastname,
      firstname,
      patronimic,
      birthday,
      phone_mobile,
      e_mail,
      snils,
      inn,
      inn_result,
      uprid_result,
      uprid_channel,
      gender,
      pass_serial,
      pass_number,
      pass_issuer,
      pass_issuer_code,
      pass_issue_date,
      birthplace,
      reg_region,
      reg_region_key,
      reg_region_key_kladr,
      reg_city,
      reg_city_key,
      reg_city_key_kladr,
      reg_settlement,
      reg_settlement_key,
      reg_settlement_key_kladr,
      reg_street,
      reg_street_key,
      reg_street_key_kladr,
      reg_house,
      reg_housing,
      reg_building,
      reg_flat,
      family_status,
      emloyment_type,
      organization_type,
      company_occupation,
      position_type,
      last_work_term,
      monthly_income,
      loan_purpose,
      litigation,
      bankruptcy,
      card_mask,
      card_expiration_date,
      gateway_name,
      card_token,
      esia_flag,
      device_type,
      client_ip,
      device_system,
      browser,
      browser_version,
      cession_of_claims_agreed,
      additional_income,
      full_identification_result,
      reg_address_full,
      nbki_md5,
      equifax_md5,
      rus_standart_md5,
      service_agreement_md5,
      vcid,
      clicked_from,
      juicy_session_id
    )
    VALUES (
      v_business_key,
      v_source_id,
      v_wm_id,
      v_click_id,
      v_offer_id,
      v_source_id_last,
      v_wm_id_last,
      v_click_id_last,
      v_offer_id_last,
      v_utm_medium,
      v_utm_campaign,
      v_utm_term,
      v_utm_content,
      v_utm_medium_last,
      v_utm_campaign_last,
      v_utm_term_last,
      v_utm_content_last,
      v_req_sum,
      v_req_term,
      UPPER(BTRIM(COALESCE(v_lastname, ''), ' ')),
      UPPER(BTRIM(COALESCE(v_firstname, ''), ' ')),
      UPPER(BTRIM(COALESCE(v_patronimic, ''), ' ')),
      v_birthday,
      v_phone_mobile,
      v_email,
      v_snils,
      v_inn,
      v_inn_result,
      v_uprid_result,
      v_uprid_channel,
      v_gender,
      v_pass_serial,
      v_pass_number,
      UPPER(COALESCE(v_pass_issuer, '')),
      v_pass_issuer_code,
      v_pass_issue_date,
      UPPER(COALESCE(v_birthplace, '')),
      v_reg_region,
      v_reg_region_key,
      v_reg_region_key_kladr,
      v_reg_city,
      v_reg_city_key,
      v_reg_city_key_kladr,
      v_reg_settlement,
      v_reg_settlement_key,
      v_reg_settlement_key_kladr,
      v_reg_street,
      v_reg_street_key,
      v_reg_street_key_kladr,
      v_reg_house,
      v_reg_housing,
      v_reg_building,
      v_reg_flat,
      v_family_status,
      v_emloyment_type,
      v_organization_type,
      v_company_occupation,
      v_position_type,
      v_last_work_term,
      v_monthly_income,
      v_loan_purpose,
      v_litigation,
      v_bankruptcy,
      v_card_mask,
      v_card_expiration_date,
      v_gateway_name,
      v_card_token,
      v_esia_flag,
      v_device_type,
      v_client_ip,
      v_device_system,
      v_browser,
      v_browser_version,
      v_cession_of_claims_agreed,
      v_additional_income,
      UPPER(COALESCE(v_full_identification_result, '')),
      v_reg_address_full,
      v_nbki_md5,
      v_equifax_md5,
      v_rus_standart_md5,
      v_service_agreement_md5,
      v_vcid,
      v_clicked_from,
      v_juicy_session_id
    )
    RETURNING loanapp_review_id
    INTO v_loanapp_review_id;

    -- Создание заявки в loan_issue.application
    SELECT c.result, c.result_str, c.proc_key, c.application_key
    FROM eis_processes.convert_to_li_app_leasing(v_loanapp_review_id, v_business_key) AS c
    INTO v_result, v_result_str, v_process_key, v_application_key;

    -- Проверка результата конвертации
    IF v_result = -1 THEN
        result = -1;
        result_str = v_result_str;
        response = jsonb_build_object(
            'error', v_result_str
        )::VARCHAR;
        
        PERFORM api.add_log(
            'ERROR', 
            'Ошибка конвертации в parse_request_for_loanapp_review_leasing: ' || v_result_str, 
            'parse_request_for_loanapp_review_leasing', 
            jsonb_build_object(
                '_method', _method,
                'business_key', v_business_key
            ), 
            v_context
        );
        RETURN;
    END IF;

    -- Создание объекта рассмотрения заявки
    INSERT INTO eis_processes.app_loanapp_review_leasing (
      loanapp_review_id,
      application_key,
      process_key
    )
    VALUES (
      v_loanapp_review_id,
      v_application_key,
      v_process_key
    );

    -- Вставка данных в application_uprid
    INSERT INTO loan_issue.application_uprid (
      application_key, 
      ext_object_type, 
      ext_object_key, 
      inn_status, 
      inn, 
      uprid_status
    )
    VALUES (
      v_application_key, 
      'Leasing', 
      v_application_key, 
      UPPER(COALESCE(v_inn_result, '')),
      v_inn, 
      UPPER(COALESCE(v_uprid_result, ''))
    );

    result = 1;
    result_str = 'Ok';
    RETURN;

EXCEPTION WHEN OTHERS THEN
    -- Обработка неожиданных ошибок
    result = -1;
    result_str = SQLERRM;
    GET STACKED DIAGNOSTICS v_context = PG_EXCEPTION_CONTEXT;
    PERFORM api.add_log(
        'ERROR', 
        'Неожиданная ошибка в parse_request_for_loanapp_review_leasing', 
        'parse_request_for_loanapp_review_leasing', 
        jsonb_build_object(
            'sql_error', SQLERRM,
            '_method', _method,
            '_request', _request
        ), 
        v_context
    );
    response = jsonb_build_object(
        'error', 'Неожиданная ошибка: ' || SQLERRM
    )::VARCHAR;
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
    v__request_log_key INTEGER;
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
    
    INSERT INTO 
      api.request_log
    (
      method_name,
      request
    )
    VALUES (
      _method,
      _request
    )
    RETURNING
    	request_log_key
    INTO
    	v__request_log_key;   

    -- Формируем динамический SQL скрипт, который приримает _request как 
    -- входной параметр, а _validate_run_method - это имя метода 
    -- валидации
    v__sql = 'SELECT * FROM ' || _run_method || '($1, $2)';
    BEGIN
        EXECUTE v__sql USING _method, _request INTO v__rec__run_method;
    EXCEPTION
        WHEN OTHERS THEN
            result = -1;
            result_str = 'Ошибка при выполнении запроса: ' || SQLERRM;
            
            UPDATE 
              api.request_log 
            SET 
              run_result = result,
              run_result_str = result_str
            WHERE 
              request_log_key = v__request_log_key
            ;            
            
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
        
        UPDATE 
          api.request_log 
        SET 
          run_result = result,
          run_result_str = result_str
        WHERE 
          request_log_key = v__request_log_key
        ;     
        
        RETURN;
    END IF;

    result_str = 'OK';
    result = 1;
    response = v__rec__run_method.response;
    UPDATE 
      api.request_log 
    SET 
      run_result = result,
      run_result_str = result_str,
      run_response = v__rec__run_method.response
    WHERE 
      request_log_key = v__request_log_key
    ;     
    
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