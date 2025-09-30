INSERT INTO api.dic_param (param_key,param_name,param_descr,active,created_on) VALUES
	 (1,'api_title_short','Название сервиса API',1,'2025-09-19 15:56:25.120934'),
	 (3,'show_debug_info','Отображать отладочную информацию (0/1)',1,'2025-09-22 16:16:21.243162'),
	 (5,'log_service_request_body','Логировать ли тело запроса',1,'2025-09-25 12:25:16.77411'),
	 (6,'log_service_post','Логировать ли массив POST при запросе к сервису',1,'2025-09-25 12:25:55.132946'),
	 (8,'enable_hmac','Нужен ли HMAC для запросов',1,'2025-09-25 15:17:18.198034'),
	 (9,'api_secret','Ключ API',1,'2025-09-25 15:34:25.568586'),
	 (11,'show_log_fields','Поля api.request_log, которые отображать в списке логов',1,'2025-09-25 21:25:37.093492'),
	 (7,'add_in_debug_info_secret_data','Добавлять ли в отладочную 
информацию конфиденциальные данные 
(пароли, хеши и т.д.)',1,'2025-09-25 12:29:24.803801'),
	 (12,'enable_service_request_log','Включить логироваание запросов к сервису',1,'2025-09-29 18:43:56.291409');
INSERT INTO api.dic_param_values (param_value_key,param_key,param_value,param_category,active,created_on,descr) VALUES
	 (1,1,'Тестовый API','DEV',1,'2025-09-22 09:35:42.283993',NULL),
	 (3,3,'1','DEV',1,'2025-09-22 16:17:04.886504',NULL),
	 (38,1,'Тестовый API','WORK',1,'2025-09-24 15:02:30.965179',NULL),
	 (40,3,'1','WORK',1,'2025-09-24 15:03:13.665093',NULL),
	 (41,5,'1','DEV',1,'2025-09-25 12:26:59.638103',NULL),
	 (42,6,'1','DEV',1,'2025-09-25 12:27:10.954973',NULL),
	 (43,5,'0','WORK',1,'2025-09-25 12:27:23.750455',NULL),
	 (44,6,'0','WORK',1,'2025-09-25 12:27:33.268806',NULL),
	 (48,8,'1','WORK',1,'2025-09-25 15:17:39.789477',NULL),
	 (54,11,'[
"method_key",
"request",
"run_result",
"run_result_str",
"service_request_body",
"service_post",
"service_request_url",
"method_name"
]','DEV',1,'2025-09-25 21:27:35.668377',NULL);
INSERT INTO api.dic_param_values (param_value_key,param_key,param_value,param_category,active,created_on,descr) VALUES
	 (55,11,'[
"method_key",
"request",
"run_result",
"run_result_str",
"service_request_body",
"service_post",
"service_request_url",
"method_name"
]','WORK',1,'2025-09-25 21:27:59.995366',NULL),
	 (47,8,'1','DEV',1,'2025-09-25 15:17:30.875512',NULL),
	 (49,9,'pqdYDMmBMYIVi3nYEsWcya0Z0yr4emXy','DEV',1,'2025-09-25 15:34:57.480599',NULL),
	 (50,9,'pqdYDMmBMYIVi3nYEsWcya0Z0yr4emXy','WORK',1,'2025-09-25 15:34:57.50919',NULL),
	 (45,7,'1','DEV',1,'2025-09-25 12:30:03.04298',NULL),
	 (46,7,'1','WORK',1,'2025-09-25 12:30:11.536447',NULL),
	 (2,12,'1','DEV',1,'2025-09-29 18:58:46.630462',NULL),
	 (4,12,'1','WORK',1,'2025-09-29 18:59:13.259392',NULL);







   
INSERT INTO api.external_connect (external_connect_key,connect_name) VALUES
	 (1,'asuz'),
	 (2,'api_db');
INSERT INTO api.external_connect_params (external_connect_param_key,created_on,db_host,db_port,db_username,db_password,db_database,inner_db_type,external_connect_key) VALUES
	 (1,'2025-09-23 13:50:28.827235','172.17.0.1','5432','tetis','j3qq4h7h2v','api_db','DEV',2),
	 (2,'2025-09-24 13:16:42.147234','vd-dbdev02.vd.ru','5432','ois_user','hOtzTb7n%oyLNmKN','asuz','DEV',1),
	 (3,'2025-09-24 15:37:10.247353','vd-dbasuz01.vd.ru','5432','ois_user','hOtzTb7n%oyLNmKN','asuz','WORK',1);








INSERT INTO api.methods (method_key,method_name,title,created_on,description,html_description,request_json_schema,require_request_body,test_form__show_file_upload_input,request_body_must_be_json,response_type) VALUES
	 (2,'test','Тестовый метод','2025-09-19 16:18:51.487','Описание тестового метода','s','',1,0,1,NULL),
	 (10,'loan_docs_leasing','Формирование документов Лизинг','2025-09-25 20:35:49.892','Формирование документов Лизинг','<pre>
    METHOD: loan_docs_leasing - Сформировать ссылки на документы по займу Лизинг

    REQUEST:
    {
        "business-key": "abcdef-ghijklmop-qrstuv-wxyz", //бизнес-ключ процесса для отправки данных в бек-энд камунды
        "agreed_loan_terms_id": "111224566" //
    }
    
    HMAC: MD5(REQUEST, PASSWORD)
    
    RESPONSE:
    {
        "response":
        {
            "status": "SUCCESS/FAIL",
            "message": ""
        },
    
        "hmac": MD5(response, PASSWORD)
    }
</pre>','{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "business-key": {
      "type": "string"
    },
    "agreed_loan_terms_id": {
      "type": "string"
    }
  },
  "required": [
    "business-key",
    "agreed_loan_terms_id"
  ]
}',1,0,1,'eis'),
	 (3,'check_client_data','Метод проверки заявочных данных','2025-09-23 16:19:31.749','Метод проверки заявочных данных','<pre>
	METHOD: check_client_data - Метод проверки заявочных данных
	REQUEST:
	{
		"business-key": "abcdef-ghijklmop-qrstuv-wxyz", //бизнес-ключ процесса для отправки данных в бек-энд камунды
		"req_sum": "40000.00", //сумма займа
		"req_term": "12M", //срок займа
		"lastname": "ИВАНОВ", //фамилия
		"firstname": "ИВАН", //имя
		"patronimic": "ИВАНОВИЧ", //отчество
		"birthday": "01.01.2000", //дата рождения
		"phone_mobile": "+79111111111", //мобильный телефон
		"email": "ivanov1@mail.ru", //мобильный телефон
		"inn": "12345678910", //инн
		"gender": "M", //пол
		"pass_serial": "2220", //серия паспорта
		"pass_number": "000000", //номер паспорта
		"pass_issuer": "Московским РОВД", //кем выдан паспорт
		"pass_issuer_code": "111-111", //код подразделения
		"pass_issue_date": "10.10.2005", //дата выдачи паспорта
		"birthplace": "Москва", //место рождения
		"reg_address": "Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
		"fact_address": "Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
		"family_status": "MARRIED", //семейное положение (справочник)
		"emloyment_type": "EMPLOYED", // справочник dic_types_of_income
		"organization_type": "COMMERCIAL_ORGANIZATION", // (справочник)
		"company_occupation": "COMMERCE", // (справочник)
		"position_type": "MANAGEMENT", // (справочник)
		"last_work_term": "2Y_AND_MORE", // (справочник)
		"monthly_income": "50000.00" //доход
	}

	HMAC: MD5(REQUEST, PASSWORD)

	RESPONSE:
	{
		"response":
		{
			"status": "SUCCESS/FAIL",
			"message": "",
			"is_black_list": true, //false
			"is_active_debt": true, //false
			"is_debt_holiday": true //false
		},
		"hmac": MD5(response, PASSWORD)
	}
</pre>



','{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "business-key": {
      "type": "string"
    },
    "req_sum": {
      "type": "string"
    },
    "req_term": {
      "type": "string"
    },
    "lastname": {
      "type": "string"
    },
    "firstname": {
      "type": "string"
    },
    "patronimic": {
      "type": "string"
    },
    "birthday": {
      "type": "string"
    },
    "phone_mobile": {
      "type": "string"
    },
    "email": {
      "type": "string"
    },
    "inn": {
      "type": "string"
    },
    "gender": {
      "type": "string"
    },
    "pass_serial": {
      "type": "string"
    },
    "pass_number": {
      "type": "string"
    },
    "pass_issuer": {
      "type": "string"
    },
    "pass_issuer_code": {
      "type": "string"
    },
    "pass_issue_date": {
      "type": "string"
    },
    "birthplace": {
      "type": "string"
    },
    "reg_address": {
      "type": "string"
    },
    "fact_address": {
      "type": "string"
    },
    "family_status": {
      "type": "string"
    },
    "emloyment_type": {
      "type": "string"
    },
    "organization_type": {
      "type": "string"
    },
    "company_occupation": {
      "type": "string"
    },
    "position_type": {
      "type": "string"
    },
    "last_work_term": {
      "type": "string"
    },
    "monthly_income": {
      "type": "string"
    }
  },
  "required": [
    "business-key",
    "req_sum",
    "req_term",
    "lastname",
    "firstname",
    "birthday",
    "phone_mobile",
    "gender",
    "pass_serial",
    "pass_number",
    "pass_issuer",
    "pass_issuer_code",
    "pass_issue_date",
    "birthplace",
    "reg_address",
    "fact_address",
    "family_status",
    "emloyment_type",
    "monthly_income"
  ]
}',1,0,1,'eis'),
	 (7,'get_approved_for_transfer_2','Получить одобрение на перевод (кредитные риски)','2025-09-25 20:17:44.460','Получить одобрение на перевод (кредитные риски)','<pre>
	METHOD: get_approved_for_transfer_2 - Получить одобрение на перевод (кредитные риски)
	REQUEST:
	{
		"business-key": "abcdef-ghijklmop-qrstuv-wxyz", //бизнес-ключ процесса для отправки данных в бек-энд камунды
		"transfer_sum": "15000.00", //сумма перевода
		"lastname": "Иванов", // фамилия
		"firstname": "Иван", // имя
		"patronimic": "Иванович", // отчество
		"birthday": "10.10.1985", // дата рождения
		"gender": "M", //Пол, M-Мужской, F-Женский
		"phone_mobile": "+79111111111", //номер мобильного телефона
		"email": "ivanov@mail.ru", //почта
		"snils": "111-111-111 11", //снилс
		"inn": "123456789123", //ИНН
		"pass_serial": "0000", //серия паспорта
		"pass_number": "000000", //номер паспорта
		"pass_issuer_code": "111-111", //код подразделения
		"payment_method_id": "SBP", // (card/sbp/и т.д.)
		"card_mask": "111222******23333", //маска карты
		"card_expiration_date": "12/24", //срок действия карты
		"gateway_name": "Монета", //наименование шлюза 
		"card_token": "dfsd454asd5", // токен карты
		"sbp_bank_key": "100000234400055",
		"pam_fio": "IVANOV",
		"full_identification": "SUCCESS",
		"agreed_loan_terms_id": "111224566"
	}

	HMAC: MD5(REQUEST, PASSWORD)

	RESPONSE:
	{
		"response":
		{
			"status": "SUCCESS/FAIL",
			"message": "",
			"result": "APPROVE_LAUNCHED" // INCORRECT_LOAN_TERMS_ID
		},
		"hmac": MD5(response, PASSWORD)
	}
</pre>



','{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "business-key": {
      "type": "string"
    },
    "transfer_sum": {
      "type": "string"
    },
    "lastname": {
      "type": "string"
    },
    "firstname": {
      "type": "string"
    },
    "patronimic": {
      "type": "string"
    },
    "birthday": {
      "type": "string"
    },
    "gender": {
      "type": "string"
    },
    "phone_mobile": {
      "type": "string"
    },
    "email": {
      "type": "string"
    },
    "snils": {
      "type": "string"
    },
    "inn": {
      "type": "string"
    },
    "pass_serial": {
      "type": "string"
    },
    "pass_number": {
      "type": "string"
    },
    "pass_issuer_code": {
      "type": "string"
    },
    "payment_method_id": {
      "type": "string"
    },
    "card_mask": {
      "type": "string"
    },
    "card_expiration_date": {
      "type": "string"
    },
    "gateway_name": {
      "type": "string"
    },
    "card_token": {
      "type": "string"
    },
    "sbp_bank_key": {
      "type": "string"
    },
    "pam_fio": {
      "type": "string"
    },
    "full_identification": {
      "type": "string"
    },
    "agreed_loan_terms_id": {
      "type": "string"
    }
  },
  "required": [
    "business-key",
    "transfer_sum",
    "lastname",
    "firstname",
    "birthday",
    "gender",
    "phone_mobile",
    "pass_serial",
    "pass_number",
    "pass_issuer_code",
    "agreed_loan_terms_id"
  ]
}',1,0,1,'eis'),
	 (8,'loanapp_review_5','Рассмотрение кредитной заявки','2025-09-25 20:30:24.127','Рассмотрение кредитной заявки','<pre>
	METHOD: loanapp_review_5 - Рассмотрение кредитной заявки
	REQUEST:
	{
		"business-key": "abcdef-ghijklmop-qrstuv-wxyz", //бизнес-ключ процесса для отправки данных в бек-энд камунды
		"source_id": "leads", //
		"wm_id": "12345", //
		"click_id": "234kjjkh234wefewrg", //
		"offer_id": "1", //
		"source_id_last": "leads", //
		"wm_id_last": "12345", //
		"click_id_last": "234kjjkh234wefewrg", //
		"offer_id_last": "1", //
		"utm_medium": "", //
		"utm_campaign": "", //
		"utm_term": "", //
		"utm_content": "", //
		"utm_medium_last": "", //
		"utm_campaign_last": "", //
		"utm_term_last": "", //
		"utm_content_last": "", //
		"req_sum": "40000.00", //сумма займа
		"req_term": "12M", //срок займа
		"lastname": "ИВАНОВ", //фамилия
		"firstname": "ИВАН", //имя
		"patronimic": "ИВАНОВИЧ", //отчество (необязательный параметр)
		"birthday": "10.10.1998", //дата рождения
		"phone_mobile": "+79111111111", //номер мобильного телефона
		"email": "ivanov@mail.ru", //почта
		"snils": "111-111-111 11", //снилс
		"inn": "123456789123", //ИНН
		"inn_result": "varchar",
		"uprid_result": "varchar",
		"uprid_channel": "varchar",
		"gender": "M", //Пол, M-Мужской, F-Женский
		"pass_serial": "0000", //серия паспорта
		"pass_number": "000000", //номер паспорта
		"pass_issuer": "Московским РОВД", //кем выдан паспорт
		"pass_issuer_code": "111-111", //код подразделения
		"pass_issue_date": "10.10.2005", //дата выдачи паспорта
		"birthplace": "Москва", //место рождения
		"reg_address_full": {
			"full_address": " Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
			"full_address_with_index": "468320 Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
			"city_name": "Байконур",
			"city_object": {
				"id": "9900000000000",
				"name": "Байконур",
				"zip": "468320",
				"type": "Город",
				"type_short": "г",
				"content_type": "city",
				"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
				"parent_guid": "",
				"cadnum": "",
				"parents": [
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "city",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": []
					}
				]
			},
			"street_name": "им Генерал-полковника А.А.Максимова",
			"street_object": {
				"id": "99000000000003500",
				"name": "им Генерал-полковника А.А.Максимова",
				"zip": "468321",
				"type": "Улица",
				"type_short": "ул",
				"content_type": "street",
				"guid": "ef7972a7-b80b-4f0b-8d7f-439b919b9915",
				"parent_guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
				"cadnum": "",
				"parents": [
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "region",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					},
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "city",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					}
				]
			},
			"building_name": "12а",
			"building_object": {
				"id": "9900000000000350001",
				"name": "12а",
				"zip": "468321",
				"type": "дом",
				"type_short": "д",
				"content_type": "building",
				"guid": "0cbc3fa5-3bbb-4a2d-809d-033e7af1bc20",
				"parent_guid": "ef7972a7-b80b-4f0b-8d7f-439b919b9915",
				"cadnum": "",
				"parents": [
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "region",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					},
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "city",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					},
					{
						"id": "99000000000003500",
						"name": "им Генерал-полковника А.А.Максимова",
						"zip": "468321",
						"type": "Улица",
						"type_short": "ул",
						"content_type": "street",
						"guid": "ef7972a7-b80b-4f0b-8d7f-439b919b9915",
						"parent_guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"cadnum": "",
						"parents": null
					}
				]
			},
			"flat_name": "123"
		},
		"reg_region": "Московская область", //регион
		"reg_region_key": "77", //код-кладр
		"reg_city": "Москва", //город
		"reg_city_key": "77", //код-кладр
		"reg_settlement": "Москва", //населенный пункт
		"reg_settlement_key": "77", //код-кладр
		"reg_street": "ул. Маяковского", //улица
		"reg_street_key": "77000015", //код-кладр
		"reg_house": "5", //дом
		"reg_housing": "", //
		"reg_building": "", //
		"reg_flat": "150", //квартира
		"family_status": "MARRIED", //семейное положение (справочник)
		"emloyment_type": "EMPLOYED", // справочник dic_types_of_income
		"organization_type": "COMMERCIAL_ORGANIZATION", // (справочник)
		"company_occupation": "COMMERCE", // (справочник)
		"position_type": "MANAGEMENT", // (справочник)
		"last_work_term": "2Y_AND_MORE", // (справочник)
		"monthly_income": "50000.00", //
		"loan_purpose": "Ремонт", //
		"litigation": "false", //
		"bankruptcy": "false", //
		"card_mask": "111222******23333", //маска карты
		"card_expiration_date": "12/24", //срок действия карты
		"gateway_name": "Монета", //наименование шлюза	
		"card_token": "dfsd454asd5", //	токен карты		
		"esia_flag": "1",
	    "device_type": "DESKTOP",
	    "client_ip": "192.168.104.213",
	    "device_system": "WINDOWS_10",
	    "browser": "Firefox 10",
	    "browser_version": "104.0",
		"cession_of_claims_agreed": "true",
		"additional_income": "5000.00",
		"full_identification_result": "SUCCESS", // результат полной идентификации SUCCESS/FRAUD
		"vcid": "abcdefg",
		"clicked_from": "https://cabinet.vivadengi.ru",
		"juicy_session_id": "w.20240315140854eb9ccd1e-c33a-11ed-b7d2-9a7fba6a3e21.C_GS",
		"agreemets_part2_md5": {
			"nbki_md5": "a;sdlkj120930901",
			"equifax_md5": "a;sdlkj120930901",
			"rus_standart_md5": "a;sdlkj120930901",
			"service_agreement_md5": "a;sdlkj120930901"
		}
	}

	HMAC: MD5(REQUEST, PASSWORD)

	RESPONSE:
	{
		"response":
		{
			"status": "SUCCESS/FAIL",
			"message": ""
		},
		"hmac": MD5(response, PASSWORD)
	}
</pre>','{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "business-key": {
      "type": "string"
    },
    "source_id": {
      "type": "string"
    },
    "wm_id": {
      "type": "string"
    },
    "click_id": {
      "type": "string"
    },
    "offer_id": {
      "type": "string"
    },
    "source_id_last": {
      "type": "string"
    },
    "wm_id_last": {
      "type": "string"
    },
    "click_id_last": {
      "type": "string"
    },
    "offer_id_last": {
      "type": "string"
    },
    "utm_medium": {
      "type": "string"
    },
    "utm_campaign": {
      "type": "string"
    },
    "utm_term": {
      "type": "string"
    },
    "utm_content": {
      "type": "string"
    },
    "utm_medium_last": {
      "type": "string"
    },
    "utm_campaign_last": {
      "type": "string"
    },
    "utm_term_last": {
      "type": "string"
    },
    "utm_content_last": {
      "type": "string"
    },
    "req_sum": {
      "type": "number"
    },
    "req_term": {
      "type": "string"
    },
    "lastname": {
      "type": "string"
    },
    "firstname": {
      "type": "string"
    },
    "patronimic": {
      "type": "string"
    },
    "birthday": {
      "type": "string"
    },
    "phone_mobile": {
      "type": "string"
    },
    "email": {
      "type": "string"
    },
    "snils": {
      "type": "string"
    },
    "inn": {
      "type": "string"
    },
    "inn_result": {
      "type": "string"
    },
    "uprid_result": {
      "type": "string"
    },
    "uprid_channel": {
      "type": "string"
    },
    "gender": {
      "type": "string"
    },
    "pass_serial": {
      "type": "string"
    },
    "pass_number": {
      "type": "string"
    },
    "pass_issuer": {
      "type": "string"
    },
    "pass_issuer_code": {
      "type": "string"
    },
    "pass_issue_date": {
      "type": "string"
    },
    "birthplace": {
      "type": "string"
    },
    "reg_address_full": {
      "type": "object",
      "properties": {
        "full_address": {
          "type": "string"
        },
        "full_address_with_index": {
          "type": "string"
        },
        "city_name": {
          "type": "string"
        },
        "city_object": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            },
            "zip": {
              "type": "string"
            },
            "type": {
              "type": "string"
            },
            "type_short": {
              "type": "string"
            },
            "content_type": {
              "type": "string"
            },
            "guid": {
              "type": "string"
            },
            "parent_guid": {
              "type": "string"
            },
            "cadnum": {
              "type": "string"
            },
            "parents": {
              "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "array",
                      "items": {}
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                }
              ]
            }
          },
          "required": [
            "id",
            "name",
            "zip",
            "type",
            "type_short",
            "content_type",
            "guid",
            "parent_guid",
            "cadnum",
            "parents"
          ]
        },
        "street_name": {
          "type": "string"
        },
        "street_object": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            },
            "zip": {
              "type": "string"
            },
            "type": {
              "type": "string"
            },
            "type_short": {
              "type": "string"
            },
            "content_type": {
              "type": "string"
            },
            "guid": {
              "type": "string"
            },
            "parent_guid": {
              "type": "string"
            },
            "cadnum": {
              "type": "string"
            },
            "parents": {
              "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                },
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                }
              ]
            }
          },
          "required": [
            "id",
            "name",
            "zip",
            "type",
            "type_short",
            "content_type",
            "guid",
            "parent_guid",
            "cadnum",
            "parents"
          ]
        },
        "building_name": {
          "type": "string"
        },
        "building_object": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            },
            "zip": {
              "type": "string"
            },
            "type": {
              "type": "string"
            },
            "type_short": {
              "type": "string"
            },
            "content_type": {
              "type": "string"
            },
            "guid": {
              "type": "string"
            },
            "parent_guid": {
              "type": "string"
            },
            "cadnum": {
              "type": "string"
            },
            "parents": {
              "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                },
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                },
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                }
              ]
            }
          },
          "required": [
            "id",
            "name",
            "zip",
            "type",
            "type_short",
            "content_type",
            "guid",
            "parent_guid",
            "cadnum",
            "parents"
          ]
        },
        "flat_name": {
          "type": "string"
        }
      },
      "required": [
        "full_address",
        "full_address_with_index",
        "city_name",
        "city_object",
        "street_name",
        "street_object",
        "building_name",
        "building_object",
        "flat_name"
      ]
    },
    "reg_region": {
      "type": "string"
    },
    "reg_region_key": {
      "type": "string"
    },
    "reg_city": {
      "type": "string"
    },
    "reg_city_key": {
      "type": "string"
    },
    "reg_settlement": {
      "type": "string"
    },
    "reg_settlement_key": {
      "type": "string"
    },
    "reg_street": {
      "type": "string"
    },
    "reg_street_key": {
      "type": "string"
    },
    "reg_house": {
      "type": "string"
    },
    "reg_housing": {
      "type": "string"
    },
    "reg_building": {
      "type": "string"
    },
    "reg_flat": {
      "type": "string"
    },
    "family_status": {
      "type": "string"
    },
    "emloyment_type": {
      "type": "string"
    },
    "organization_type": {
      "type": "string"
    },
    "company_occupation": {
      "type": "string"
    },
    "position_type": {
      "type": "string"
    },
    "last_work_term": {
      "type": "string"
    },
    "monthly_income": {
      "type": "number"
    },
    "loan_purpose": {
      "type": "string"
    },
    "litigation": {
      "type": "string"
    },
    "bankruptcy": {
      "type": "string"
    },
    "esia_flag": {
      "type": "integer"
    },
    "device_type": {
      "type": "string"
    },
    "client_ip": {
      "type": "string"
    },
    "device_system": {
      "type": "string"
    },
    "browser": {
      "type": "string"
    },
    "browser_version": {
      "type": "string"
    },
    "cession_of_claims_agreed": {
      "type": "string"
    },
    "additional_income": {
      "type": "string"
    },
    "full_identification_result": {
      "type": "string"
    },
    "vcid": {
      "type": "string"
    },
    "clicked_from": {
      "type": "string"
    },
    "juicy_session_id": {
      "type": "string"
    },
    "agreemets_part2_md5": {
      "type": "object",
      "properties": {
        "nbki_md5": {
          "type": "string"
        },
        "equifax_md5": {
          "type": "string"
        },
        "rus_standart_md5": {
          "type": "string"
        },
        "service_agreement_md5": {
          "type": "string"
        }
      },
      "required": [
        "nbki_md5",
        "equifax_md5",
        "rus_standart_md5",
        "service_agreement_md5"
      ]
    },
    "card_mask": {
      "type": "string"
    },
    "card_expiration_date": {
      "type": "string"
    },
    "gateway_name": {
      "type": "string"
    },
    "card_token": {
      "type": "string"
    }
  },
  "required": [
    "business-key",
    "req_sum",
    "req_term",
    "lastname",
    "firstname",
    "birthday",
    "phone_mobile",
    "gender",
    "pass_serial",
    "pass_number",
    "pass_issuer",
    "pass_issuer_code",
    "pass_issue_date",
    "birthplace",
    "family_status",
    "emloyment_type",
    "monthly_income",
    "loan_purpose",
    "litigation",
    "bankruptcy",
    "agreemets_part2_md5"
  ]
}',1,0,1,'eis'),
	 (9,'loanapp_review_leasing','Рассмотрение кредитной заявки Лизинг','2025-09-25 20:32:15.097','Рассмотрение кредитной заявки Лизинг','<pre>
	METHOD: loanapp_review_leasing - Рассмотрение кредитной заявки Лизинг
	REQUEST:
	{
		"business-key": "abcdef-ghijklmop-qrstuv-wxyz", //бизнес-ключ процесса для отправки данных в бек-энд камунды
		"source_id": "leads", //
		"wm_id": "12345", //
		"click_id": "234kjjkh234wefewrg", //
		"offer_id": "1", //
		"source_id_last": "leads", //
		"wm_id_last": "12345", //
		"click_id_last": "234kjjkh234wefewrg", //
		"offer_id_last": "1", //
		"utm_medium": "", //
		"utm_campaign": "", //
		"utm_term": "", //
		"utm_content": "", //
		"utm_medium_last": "", //
		"utm_campaign_last": "", //
		"utm_term_last": "", //
		"utm_content_last": "", //
		"req_sum": "40000.00", //сумма займа
		"req_term": "12M", //срок займа
		"lastname": "ИВАНОВ", //фамилия
		"firstname": "ИВАН", //имя
		"patronimic": "ИВАНОВИЧ", //отчество (необязательный параметр)
		"birthday": "10.10.1998", //дата рождения
		"phone_mobile": "+79111111111", //номер мобильного телефона
		"email": "ivanov@mail.ru", //почта
		"snils": "111-111-111 11", //снилс
		"inn": "123456789123", //ИНН
		"inn_result": "varchar",
		"uprid_result": "varchar",
		"uprid_channel": "varchar",
		"gender": "M", //Пол, M-Мужской, F-Женский
		"pass_serial": "0000", //серия паспорта
		"pass_number": "000000", //номер паспорта
		"pass_issuer": "Московским РОВД", //кем выдан паспорт
		"pass_issuer_code": "111-111", //код подразделения
		"pass_issue_date": "10.10.2005", //дата выдачи паспорта
		"birthplace": "Москва", //место рождения
		"reg_address_full": {
			"full_address": " Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
			"full_address_with_index": "468320 Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
			"city_name": "Байконур",
			"city_object": {
				"id": "9900000000000",
				"name": "Байконур",
				"zip": "468320",
				"type": "Город",
				"type_short": "г",
				"content_type": "city",
				"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
				"parent_guid": "",
				"cadnum": "",
				"parents": [
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "city",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": []
					}
				]
			},
			"street_name": "им Генерал-полковника А.А.Максимова",
			"street_object": {
				"id": "99000000000003500",
				"name": "им Генерал-полковника А.А.Максимова",
				"zip": "468321",
				"type": "Улица",
				"type_short": "ул",
				"content_type": "street",
				"guid": "ef7972a7-b80b-4f0b-8d7f-439b919b9915",
				"parent_guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
				"cadnum": "",
				"parents": [
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "region",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					},
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "city",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					}
				]
			},
			"building_name": "12а",
			"building_object": {
				"id": "9900000000000350001",
				"name": "12а",
				"zip": "468321",
				"type": "дом",
				"type_short": "д",
				"content_type": "building",
				"guid": "0cbc3fa5-3bbb-4a2d-809d-033e7af1bc20",
				"parent_guid": "ef7972a7-b80b-4f0b-8d7f-439b919b9915",
				"cadnum": "",
				"parents": [
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "region",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					},
					{
						"id": "9900000000000",
						"name": "Байконур",
						"zip": "468320",
						"type": "Город",
						"type_short": "г",
						"content_type": "city",
						"guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"parent_guid": "",
						"cadnum": "",
						"parents": null
					},
					{
						"id": "99000000000003500",
						"name": "им Генерал-полковника А.А.Максимова",
						"zip": "468321",
						"type": "Улица",
						"type_short": "ул",
						"content_type": "street",
						"guid": "ef7972a7-b80b-4f0b-8d7f-439b919b9915",
						"parent_guid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
						"cadnum": "",
						"parents": null
					}
				]
			},
			"flat_name": "123"
		},
		"reg_region": "Московская область", //регион
		"reg_region_key": "77", //код-кладр
		"reg_city": "Москва", //город
		"reg_city_key": "77", //код-кладр
		"reg_settlement": "Москва", //населенный пункт
		"reg_settlement_key": "77", //код-кладр
		"reg_street": "ул. Маяковского", //улица
		"reg_street_key": "77000015", //код-кладр
		"reg_house": "5", //дом
		"reg_housing": "", //
		"reg_building": "", //
		"reg_flat": "150", //квартира
		"family_status": "MARRIED", //семейное положение (справочник)
		"emloyment_type": "EMPLOYED", // справочник dic_types_of_income
		"organization_type": "COMMERCIAL_ORGANIZATION", // (справочник)
		"company_occupation": "COMMERCE", // (справочник)
		"position_type": "MANAGEMENT", // (справочник)
		"last_work_term": "2Y_AND_MORE", // (справочник)
		"monthly_income": "50000.00", //
		"loan_purpose": "Ремонт", //
		"litigation": "false", //
		"bankruptcy": "false", //
		"card_mask": "111222******23333", //маска карты
		"card_expiration_date": "12/24", //срок действия карты
		"gateway_name": "Монета", //наименование шлюза	
		"card_token": "dfsd454asd5", //	токен карты		
		"esia_flag": "1",
	    "device_type": "DESKTOP",
	    "client_ip": "192.168.104.213",
	    "device_system": "WINDOWS_10",
	    "browser": "Firefox 10",
	    "browser_version": "104.0",
		"cession_of_claims_agreed": "true",
		"additional_income": "5000.00",
		"full_identification_result": "SUCCESS", // результат полной идентификации SUCCESS/FRAUD
		"vcid": "abcdefg",
		"clicked_from": "https://cabinet.vivadengi.ru",
		"juicy_session_id": "w.20240315140854eb9ccd1e-c33a-11ed-b7d2-9a7fba6a3e21.C_GS",
		"agreemets_part2_md5": {
			"nbki_md5": "a;sdlkj120930901",
			"equifax_md5": "a;sdlkj120930901",
			"rus_standart_md5": "a;sdlkj120930901",
			"service_agreement_md5": "a;sdlkj120930901"
		}
	}

	HMAC: MD5(REQUEST, PASSWORD)

	RESPONSE:
	{
		"response":
		{
			"status": "SUCCESS/FAIL",
			"message": ""
		},
		"hmac": MD5(response, PASSWORD)
	}
</pre>','{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "business-key": {
      "type": "string"
    },
    "source_id": {
      "type": "string"
    },
    "wm_id": {
      "type": "string"
    },
    "click_id": {
      "type": "string"
    },
    "offer_id": {
      "type": "string"
    },
    "source_id_last": {
      "type": "string"
    },
    "wm_id_last": {
      "type": "string"
    },
    "click_id_last": {
      "type": "string"
    },
    "offer_id_last": {
      "type": "string"
    },
    "utm_medium": {
      "type": "string"
    },
    "utm_campaign": {
      "type": "string"
    },
    "utm_term": {
      "type": "string"
    },
    "utm_content": {
      "type": "string"
    },
    "utm_medium_last": {
      "type": "string"
    },
    "utm_campaign_last": {
      "type": "string"
    },
    "utm_term_last": {
      "type": "string"
    },
    "utm_content_last": {
      "type": "string"
    },
    "req_sum": {
      "type": "string"
    },
    "req_term": {
      "type": "string"
    },
    "lastname": {
      "type": "string"
    },
    "firstname": {
      "type": "string"
    },
    "patronimic": {
      "type": "string"
    },
    "birthday": {
      "type": "string"
    },
    "phone_mobile": {
      "type": "string"
    },
    "email": {
      "type": "string"
    },
    "snils": {
      "type": "string"
    },
    "inn": {
      "type": "string"
    },
    "inn_result": {
      "type": "string"
    },
    "uprid_result": {
      "type": "string"
    },
    "uprid_channel": {
      "type": "string"
    },
    "gender": {
      "type": "string"
    },
    "pass_serial": {
      "type": "string"
    },
    "pass_number": {
      "type": "string"
    },
    "pass_issuer": {
      "type": "string"
    },
    "pass_issuer_code": {
      "type": "string"
    },
    "pass_issue_date": {
      "type": "string"
    },
    "birthplace": {
      "type": "string"
    },
    "reg_address_full": {
      "type": "object",
      "properties": {
        "full_address": {
          "type": "string"
        },
        "full_address_with_index": {
          "type": "string"
        },
        "city_name": {
          "type": "string"
        },
        "city_object": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            },
            "zip": {
              "type": "string"
            },
            "type": {
              "type": "string"
            },
            "type_short": {
              "type": "string"
            },
            "content_type": {
              "type": "string"
            },
            "guid": {
              "type": "string"
            },
            "parent_guid": {
              "type": "string"
            },
            "cadnum": {
              "type": "string"
            },
            "parents": {
              "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "array",
                      "items": {}
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                }
              ]
            }
          },
          "required": [
            "id",
            "name",
            "zip",
            "type",
            "type_short",
            "content_type",
            "guid",
            "parent_guid",
            "cadnum",
            "parents"
          ]
        },
        "street_name": {
          "type": "string"
        },
        "street_object": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            },
            "zip": {
              "type": "string"
            },
            "type": {
              "type": "string"
            },
            "type_short": {
              "type": "string"
            },
            "content_type": {
              "type": "string"
            },
            "guid": {
              "type": "string"
            },
            "parent_guid": {
              "type": "string"
            },
            "cadnum": {
              "type": "string"
            },
            "parents": {
              "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                },
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                }
              ]
            }
          },
          "required": [
            "id",
            "name",
            "zip",
            "type",
            "type_short",
            "content_type",
            "guid",
            "parent_guid",
            "cadnum",
            "parents"
          ]
        },
        "building_name": {
          "type": "string"
        },
        "building_object": {
          "type": "object",
          "properties": {
            "id": {
              "type": "string"
            },
            "name": {
              "type": "string"
            },
            "zip": {
              "type": "string"
            },
            "type": {
              "type": "string"
            },
            "type_short": {
              "type": "string"
            },
            "content_type": {
              "type": "string"
            },
            "guid": {
              "type": "string"
            },
            "parent_guid": {
              "type": "string"
            },
            "cadnum": {
              "type": "string"
            },
            "parents": {
              "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                },
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                },
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    },
                    "zip": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    },
                    "type_short": {
                      "type": "string"
                    },
                    "content_type": {
                      "type": "string"
                    },
                    "guid": {
                      "type": "string"
                    },
                    "parent_guid": {
                      "type": "string"
                    },
                    "cadnum": {
                      "type": "string"
                    },
                    "parents": {
                      "type": "null"
                    }
                  },
                  "required": [
                    "id",
                    "name",
                    "zip",
                    "type",
                    "type_short",
                    "content_type",
                    "guid",
                    "parent_guid",
                    "cadnum",
                    "parents"
                  ]
                }
              ]
            }
          },
          "required": [
            "id",
            "name",
            "zip",
            "type",
            "type_short",
            "content_type",
            "guid",
            "parent_guid",
            "cadnum",
            "parents"
          ]
        },
        "flat_name": {
          "type": "string"
        }
      },
      "required": [
        "full_address",
        "full_address_with_index",
        "city_name",
        "city_object",
        "street_name",
        "street_object",
        "building_name",
        "building_object",
        "flat_name"
      ]
    },
    "reg_region": {
      "type": "string"
    },
    "reg_region_key": {
      "type": "string"
    },
    "reg_city": {
      "type": "string"
    },
    "reg_city_key": {
      "type": "string"
    },
    "reg_settlement": {
      "type": "string"
    },
    "reg_settlement_key": {
      "type": "string"
    },
    "reg_street": {
      "type": "string"
    },
    "reg_street_key": {
      "type": "string"
    },
    "reg_house": {
      "type": "string"
    },
    "reg_housing": {
      "type": "string"
    },
    "reg_building": {
      "type": "string"
    },
    "reg_flat": {
      "type": "string"
    },
    "family_status": {
      "type": "string"
    },
    "emloyment_type": {
      "type": "string"
    },
    "organization_type": {
      "type": "string"
    },
    "company_occupation": {
      "type": "string"
    },
    "position_type": {
      "type": "string"
    },
    "last_work_term": {
      "type": "string"
    },
    "monthly_income": {
      "type": "string"
    },
    "loan_purpose": {
      "type": "string"
    },
    "litigation": {
      "type": "string"
    },
    "bankruptcy": {
      "type": "string"
    },
    "esia_flag": {
      "type": "string"
    },
    "device_type": {
      "type": "string"
    },
    "client_ip": {
      "type": "string"
    },
    "device_system": {
      "type": "string"
    },
    "browser": {
      "type": "string"
    },
    "browser_version": {
      "type": "string"
    },
    "cession_of_claims_agreed": {
      "type": "string"
    },
    "additional_income": {
      "type": "string"
    },
    "full_identification_result": {
      "type": "string"
    },
    "vcid": {
      "type": "string"
    },
    "clicked_from": {
      "type": "string"
    },
    "juicy_session_id": {
      "type": "string"
    },
    "agreemets_part2_md5": {
      "type": "object",
      "properties": {
        "nbki_md5": {
          "type": "string"
        },
        "equifax_md5": {
          "type": "string"
        },
        "rus_standart_md5": {
          "type": "string"
        },
        "service_agreement_md5": {
          "type": "string"
        }
      },
      "required": [
        "nbki_md5",
        "equifax_md5",
        "rus_standart_md5",
        "service_agreement_md5"
      ]
    },
    "agreed_loan_terms_id": {
      "type": "string"
    }
  },
  "required": [
    "business-key"
  ]
}',1,0,1,'eis'),
	 (11,'loan_finalization_leasing','Финализация выдачи займа Лизинг','2025-09-25 20:38:52.856','Финализация выдачи займа Лизинг','<pre>
    METHOD: loan_finalization_leasing - Финализация выдачи займа Лизинг
	REQUEST:
    {
        "business-key": "abcdef-ghijklmop-qrstuv-wxyz", //бизнес-ключ процесса для отправки данных в бек-энд камунды
		"agreed_loan_terms_id": "111224566",
		"transfer_money_dt": "01.01.2022",
		"loan_issue_fact": {
			"phone_number": "+79111111111",
			"phone_approval_send_dt": "19.04.2024",
			"phone_approval_code": "468321",
			"phone_approval_receive_code_dt": "19.04.2024",
			"phone_number_sign": "phone_number_sign",
			"sign_docs_send_dt": "19.04.2024",
			"sign_docs_code": "468321",
			"sign_docs_receive_code_dt": "19.04.2024"
		},
		"payment_info": "payment_info"
    }
    
    HMAC: MD5(REQUEST, PASSWORD)

	RESPONSE:
    {
        "response":
        {
            "status": "SUCCESS/FAIL",
            "message": ""
        },
        "hmac": MD5(response, PASSWORD)
    }
</pre>','{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "business-key": {
      "type": "string"
    },
    "agreed_loan_terms_id": {
      "type": "string"
    },
    "transfer_money_dt": {
      "type": "string"
    },
    "loan_issue_fact": {
      "type": "object",
      "properties": {
        "phone_number": {
          "type": "string"
        },
        "phone_approval_send_dt": {
          "type": "string"
        },
        "phone_approval_code": {
          "type": "string"
        },
        "phone_approval_receive_code_dt": {
          "type": "string"
        },
        "phone_number_sign": {
          "type": "string"
        },
        "sign_docs_send_dt": {
          "type": "string"
        },
        "sign_docs_code": {
          "type": "string"
        },
        "sign_docs_receive_code_dt": {
          "type": "string"
        }
      }
    },
    "payment_info": {
      "type": "string"
    }
  },
  "required": [
    "business-key",
    "agreed_loan_terms_id"
  ]
}',1,0,1,'eis');











INSERT INTO api.method_example (method_example_key,method_key,created_on,json_example,example_name,active) VALUES
	 (1,2,'2025-09-22 13:09:37.83225','{}','main',1),
	 (2,3,'2025-09-23 16:21:12.128469','{
  "business-key": "abcdef-ghijklmop-qrstuv-wxyz",
  "req_sum": "40000.00",
  "req_term": "12M",
  "lastname": "ИВАНОВ",
  "firstname": "ИВАН",
  "patronimic": "ИВАНОВИЧ",
  "birthday": "01.01.2000",
  "phone_mobile": "+79111111111",
  "email": "ivanov1@mail.ru",
  "inn": "12345678910",
  "gender": "M",
  "pass_serial": "2220",
  "pass_number": "000000",
  "pass_issuer": "Московским РОВД",
  "pass_issuer_code": "111-111",
  "pass_issue_date": "10.10.2005",
  "birthplace": "Москва",
  "reg_address": "Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
  "fact_address": "Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123",
  "family_status": "MARRIED",
  "emloyment_type": "EMPLOYED",
  "organization_type": "COMMERCIAL_ORGANIZATION",
  "company_occupation": "COMMERCE",
  "position_type": "MANAGEMENT",
  "last_work_term": "2Y_AND_MORE",
  "monthly_income": "50000.00"
}
','main',1),
	 (3,7,'2025-09-25 20:47:02.142557','{"business-key":"abcdef-ghijklmop-qrstuv-wxyz","transfer_sum":"15000.00","lastname":"Иванов","firstname":"Иван","patronimic":"Иванович","birthday":"10.10.1985","gender":"M","phone_mobile":"+79111111111","email":"ivanov@mail.ru","snils":"111-111-111 11","inn":"123456789123","pass_serial":"0000","pass_number":"000000","pass_issuer_code":"111-111","payment_method_id":"SBP","card_mask":"111222******23333","card_expiration_date":"12\\/24","gateway_name":"Монета","card_token":"dfsd454asd5","sbp_bank_key":"100000234400055","pam_fio":"IVANOV","full_identification":"SUCCESS","agreed_loan_terms_id":"111224566"}','main',1),
	 (4,8,'2025-09-25 20:47:52.412932','{"business-key":"abcdef-ghijklmop-qrstuv-wxyz","source_id":"leads","wm_id":"12345","click_id":"234kjjkh234wefewrg","offer_id":"1","source_id_last":"leads","wm_id_last":"12345","click_id_last":"234kjjkh234wefewrg","offer_id_last":"1","utm_medium":"","utm_campaign":"","utm_term":"","utm_content":"","utm_medium_last":"","utm_campaign_last":"","utm_term_last":"","utm_content_last":"","req_sum":"40000.00","req_term":"12M","lastname":"ИВАНОВ","firstname":"ИВАН","patronimic":"ИВАНОВИЧ","birthday":"10.10.1998","phone_mobile":"+79111111111","email":"ivanov@mail.ru","snils":"111-111-111 11","inn":"123456789123","inn_result":"varchar","uprid_result":"varchar","uprid_channel":"varchar","gender":"M","pass_serial":"0000","pass_number":"000000","pass_issuer":"Московским РОВД","pass_issuer_code":"111-111","pass_issue_date":"10.10.2005","birthplace":"Москва","reg_address_full":{"full_address":" Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123","full_address_with_index":"468320 Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123","city_name":"Байконур","city_object":{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":[{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":[]}]},"street_name":"им Генерал-полковника А.А.Максимова","street_object":{"id":"99000000000003500","name":"им Генерал-полковника А.А.Максимова","zip":"468321","type":"Улица","type_short":"ул","content_type":"street","guid":"ef7972a7-b80b-4f0b-8d7f-439b919b9915","parent_guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","cadnum":"","parents":[{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"region","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null},{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null}]},"building_name":"12а","building_object":{"id":"9900000000000350001","name":"12а","zip":"468321","type":"дом","type_short":"д","content_type":"building","guid":"0cbc3fa5-3bbb-4a2d-809d-033e7af1bc20","parent_guid":"ef7972a7-b80b-4f0b-8d7f-439b919b9915","cadnum":"","parents":[{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"region","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null},{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null},{"id":"99000000000003500","name":"им Генерал-полковника А.А.Максимова","zip":"468321","type":"Улица","type_short":"ул","content_type":"street","guid":"ef7972a7-b80b-4f0b-8d7f-439b919b9915","parent_guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","cadnum":"","parents":null}]},"flat_name":"123"},"reg_region":"Владимирская область","reg_region_key":"33","reg_city":"Владимир","reg_city_key":"33","reg_settlement":"Владимир","reg_settlement_key":"33","reg_street":"ул. Озерная","reg_street_key":"33000001000043200","reg_house":"1","reg_housing":"","reg_building":"","reg_flat":"150","family_status":"MARRIED","emloyment_type":"EMPLOYED","organization_type":"COMMERCIAL_ORGANIZATION","company_occupation":"COMMERCE","position_type":"MANAGEMENT","last_work_term":"2Y_AND_MORE","monthly_income":"50000.00","loan_purpose":"Ремонт","litigation":"false","bankruptcy":"false","esia_flag":"1","device_type":"DESKTOP","client_ip":"192.168.104.213","device_system":"WINDOWS_10","browser":"Firefox 10","browser_version":"104.0","cession_of_claims_agreed":"true","additional_income":"5000.00","full_identification_result":"SUCCESS","vcid":"abcdefg","clicked_from":"https:\\/\\/cabinet.vivadengi.ru","juicy_session_id":"w.20240315140854eb9ccd1e-c33a-11ed-b7d2-9a7fba6a3e21.C_GS","agreemets_part2_md5":{"nbki_md5":"asdlkj120930901","equifax_md5":"asdlkj120930901","rus_standart_md5":"asdlkj120930901","service_agreement_md5":"adlkj120930901"}}','main',1),
	 (5,9,'2025-09-25 20:53:53.970003','{"business-key":"abcdef-ghijklmop-qrstuv-wxyz","source_id":"leads","wm_id":"12345","click_id":"234kjjkh234wefewrg","offer_id":"1","source_id_last":"leads","wm_id_last":"12345","click_id_last":"234kjjkh234wefewrg","offer_id_last":"1","utm_medium":"","utm_campaign":"","utm_term":"","utm_content":"","utm_medium_last":"","utm_campaign_last":"","utm_term_last":"","utm_content_last":"","req_sum":"40000.00","req_term":"12M","lastname":"ИВАНОВ","firstname":"ИВАН","patronimic":"ИВАНОВИЧ","birthday":"10.10.1998","phone_mobile":"+79111111111","email":"ivanov@mail.ru","snils":"111-111-111 11","inn":"123456789123","inn_result":"varchar","uprid_result":"varchar","uprid_channel":"varchar","gender":"M","pass_serial":"0000","pass_number":"000000","pass_issuer":"Московским РОВД","pass_issuer_code":"111-111","pass_issue_date":"10.10.2005","birthplace":"Москва","reg_address_full":{"full_address":" Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123","full_address_with_index":"468320 Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123","city_name":"Байконур","city_object":{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":[{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":[]}]},"street_name":"им Генерал-полковника А.А.Максимова","street_object":{"id":"99000000000003500","name":"им Генерал-полковника А.А.Максимова","zip":"468321","type":"Улица","type_short":"ул","content_type":"street","guid":"ef7972a7-b80b-4f0b-8d7f-439b919b9915","parent_guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","cadnum":"","parents":[{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"region","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null},{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null}]},"building_name":"12а","building_object":{"id":"9900000000000350001","name":"12а","zip":"468321","type":"дом","type_short":"д","content_type":"building","guid":"0cbc3fa5-3bbb-4a2d-809d-033e7af1bc20","parent_guid":"ef7972a7-b80b-4f0b-8d7f-439b919b9915","cadnum":"","parents":[{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"region","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null},{"id":"9900000000000","name":"Байконур","zip":"468320","type":"Город","type_short":"г","content_type":"city","guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","parent_guid":"","cadnum":"","parents":null},{"id":"99000000000003500","name":"им Генерал-полковника А.А.Максимова","zip":"468321","type":"Улица","type_short":"ул","content_type":"street","guid":"ef7972a7-b80b-4f0b-8d7f-439b919b9915","parent_guid":"63ed1a35-4be6-4564-a1ec-0c51f7383314","cadnum":"","parents":null}]},"flat_name":"123"},"reg_region":"Владимирская область","reg_region_key":"33","reg_city":"Владимир","reg_city_key":"33","reg_settlement":"Владимир","reg_settlement_key":"33","reg_street":"ул. Озерная","reg_street_key":"33000001000043200","reg_house":"1","reg_housing":"","reg_building":"","reg_flat":"150","family_status":"MARRIED","emloyment_type":"EMPLOYED","organization_type":"COMMERCIAL_ORGANIZATION","company_occupation":"COMMERCE","position_type":"MANAGEMENT","last_work_term":"2Y_AND_MORE","monthly_income":"50000.00","loan_purpose":"Ремонт","litigation":"false","bankruptcy":"false","esia_flag":"1","device_type":"DESKTOP","client_ip":"192.168.104.213","device_system":"WINDOWS_10","browser":"Firefox 10","browser_version":"104.0","cession_of_claims_agreed":"true","additional_income":"5000.00","full_identification_result":"SUCCESS","vcid":"abcdefg","clicked_from":"https:\\/\\/cabinet.vivadengi.ru","juicy_session_id":"w.20240315140854eb9ccd1e-c33a-11ed-b7d2-9a7fba6a3e21.C_GS","agreemets_part2_md5":{"nbki_md5":"asdlkj120930901","equifax_md5":"asdlkj120930901","rus_standart_md5":"asdlkj120930901","service_agreement_md5":"adlkj120930901"}}','main',1),
	 (6,10,'2025-09-25 20:54:22.854697','{"business-key":"abcdef-ghijklmop-qrstuv-wxyz","agreed_loan_terms_id":"111224566"}','main',1),
	 (7,11,'2025-09-25 20:55:07.954504','{"business-key":"abcdef-ghijklmop-qrstuv-wxyz","agreed_loan_terms_id":"111224566","transfer_money_dt":"19.04.2024","loan_issue_fact":{"phone_number":"+79111111111","phone_approval_send_dt":"19.04.2024","phone_approval_code":"468321","phone_approval_receive_code_dt":"19.04.2024","phone_number_sign":"phone_number_sign","sign_docs_send_dt":"19.04.2024","sign_docs_code":"468321","sign_docs_receive_code_dt":"19.04.2024"},"payment_info":"payment_info"}','main',1);


INSERT INTO api.method_request_func_type (method_request_func_type_key,type_name,title,created_on) VALUES
	 (1,'pre_validate','Функция, которая выполняется перед валидацией тела запроса','2025-09-23 14:28:43.047485'),
	 (2,'validate','Функция, которая выполняется как валидатор тела запроса','2025-09-23 14:29:10.538275'),
	 (3,'post_validate','Функция, которая выполняется пеосле валидацией тела запроса','2025-09-23 14:29:42.782997'),
	 (4,'run','Основная функция, которая выполняется после успешной валидации как основной метод','2025-09-23 14:31:09.946329'),
	 (5,'post_run','Функция, которая выполняется после основной RUN','2025-09-23 14:32:00.767382');




INSERT INTO api.method_request_func (method_request_func_key,created_on,method_request_func_name,method_request_func_type_key,external_connect_key,method_key,return_as_run_data) VALUES
	 (2,'2025-09-23 15:04:03.253689','api.temp_run_method',1,NULL,2,1),
	 (3,'2025-09-23 15:13:29.074023','api.temp_run_method',2,NULL,2,1),
	 (4,'2025-09-24 13:19:18.182405','api.parse_request_for_check_client_data',4,1,3,1),
	 (5,'2025-09-25 23:12:35.532846','api.parse_request_for_get_approved_for_transfer_2',4,1,7,1),
	 (6,'2025-09-25 23:12:54.313564','api.parse_request_for_loanapp_review_5',4,1,8,1),
	 (7,'2025-09-25 23:13:09.340786','api.parse_request_for_loanapp_review_leasing',4,1,9,1),
	 (8,'2025-09-25 23:13:25.548267','api.parse_request_for_loan_docs_leasing',4,1,10,1),
	 (9,'2025-09-25 23:13:40.24688','api.parse_request_for_loan_finalization_leasing',4,1,11,1);


INSERT INTO api.method_setting (method_setting_key,db_type,method_key,active,log_method_request,log_method_response,emulate_response,emulate_response_body) VALUES
	 (1,'DEV',2,1,0,0,0,NULL),
	 (2,'DEV',3,1,0,0,0,NULL),
	 (3,'WORK',2,1,0,0,0,NULL),
	 (4,'WORK',3,1,0,0,0,NULL),
	 (6,'DEV',7,1,0,0,0,NULL),
	 (7,'WORK',7,1,0,0,0,NULL),
	 (10,'WORK',9,1,0,0,0,NULL),
	 (11,'DEV',9,1,0,0,0,NULL),
	 (12,'WORK',10,1,0,0,0,NULL),
	 (13,'DEV',10,1,0,0,0,NULL);
INSERT INTO api.method_setting (method_setting_key,db_type,method_key,active,log_method_request,log_method_response,emulate_response,emulate_response_body) VALUES
	 (14,'WORK',11,1,0,0,0,NULL),
	 (15,'DEV',11,1,0,0,0,NULL),
	 (9,'DEV',8,1,1,1,0,NULL),
	 (8,'WORK',8,1,1,1,0,NULL);


