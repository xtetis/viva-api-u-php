DROP TABLE IF EXISTS  api.service_request_log CASCADE; 





CREATE TABLE api.service_request_log (
	service_request_log_key int4 DEFAULT nextval('api.service_log_service_log_key_seq'::regclass) NOT NULL, -- Первичный ключ
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







TRUNCATE TABLE api.dic_param CASCADE;
TRUNCATE TABLE api.dic_param_values CASCADE;   




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


                                           