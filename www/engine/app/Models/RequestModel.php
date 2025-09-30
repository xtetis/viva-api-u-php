<?php

namespace App\Models;

use App\Models\BaseModel;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Config;

// Модель проверки сервиса
global $check_model;
global $checked_init_data;

class RequestModel extends BaseModel
{
    /**
     * Текущий метод
     */
    public $current_method = [];

    /**
     * Хеш запроса
     */
    public $hmac = '';  

    /**
     * Примеры текущего метода
     */
    public $current_method_examples = [];

    /**
     * Отображать отладочную информацию
     */
    public $show_debug_info = 0;

    /**
     * Отладочная информация
     */
    public $debug_info = [];

    /**
     * Данные ответа CURL
     */
    public $curl_response_data = [];

    /**
     * Список функций БД, которые выполняются по ходу работы метода
     */
    public $method_request_func_list = [];

    /**
     * Ключ для записи лога
     */
    public $set_request_log_key = 0;

    /**
     * Тип ответа (eis или пустая строка)
     *
     * @var string
     */
    protected string $response_type = '';

    /**
     * Стандартный вывод команды (stdout).
     *
     * @var string
     */
    protected string $proc_response = '';

    /**
     * Включена ли проверка HMAC
     */
    public $enable_hmac = 0;

    /**
     * Оригинальный стандартный вывод команды (stdout).
     *
     * @var string
     */
    protected string $proc_response_original = '';

    /**
     * Секретный ключ API
     */
    public string $api_secret = '';

    
    /**
     * Сгенерированный hmac
     */
    public $gen_hmac = '';

    public $hmac_generate_request = '';
    public $hmac_generate_string = '';
    public $hmac_generate_string_urlencoded = '';
    public $hmac_generate_string_b64encoded = '';

    /**
     * Добавить в отладочную информацию секретные данные
     */
    public $add_in_debug_info_secret_data = 0;


    /**
     * Хеш ответа
     */
    protected string $hmac_output = '';

    /**
     * Код завершения процесса.
     * (0 - успех, ненулевой - ошибка, 255 - ошибка создания процесса).
     *
     * @var int
     */
    protected int $proc_status = 0;

    /**
     * HTTP-код ответа (для curl-запросов).
     *
     * @var int
     */
    protected int $proc_http_code = 0;

    /**
     * Заголовки ответа (для curl-запросов).
     *
     * @var string
     */
    protected string $proc_headers_response = '';

    /**
     * Имя текущего метода
     */
    public $method = '';

    /**
     * Пример текущего метода
     */
    public $method_example = '';

    /**
     * Массив моделей для загрузки файлов
     */
    public $file_service_models = [];

    /**
     * Директория с примерами JSON запросов
     */
    public $directory_json = '';



    /**
     * Файл с примером текущего метода
     */
    public $example_filename = '';

    /**
     * Урл запроса к партнеру
     */
    public $partner_request_url = '';

    /**
     * Запрос
     */
    public $request = '';

    /**
     * Запрос в виде массива
     */
    public $request_array = [];

    /**
     * POST параметр request
     */
    public $request_post = '';

    /**
     * Тело запроса
     */
    public $request_body = '';

    /**
     * Список ошибок при вализации
     */
    public $errors = [];

    /**
     * Логирование запросов
     */
    public $log_request_enable = false;

    /**
     * Максиальное количество запросов в логе
     */
    public $max_log_request_count = 0;

    /**
     * Тело запроса к партнеру
     */
    public $partner_request_data = [];

    /**
     * @var array
     */
    public $partner_response_data = [];

    /**
     * Отладка
     */
    public $request_debug = '';

    /**
     * Дополнительные данные при работе сервиса
     */
    public $run_data = [];

    /**
     * Урл партнера
     */
    public $partner_url = '';

    /**
     * Имя файла с логами
     */
    public $log_filename = '';

    /**
     * Содержимое файла с описанием метода
     */
    public $html_description_content = '';

    /**
     * Уникальный идентификатор запроса
     */
    public $request_uid = '';

    /**
     * Список методов
     */
    public $method_list = [];

    /**
     * @var string
     */
    public $partner_response_body = '';

    /**
     * Ответ партнера
     */
    public $response = false;

    /**
     * @var array
     */
    public $partner_request_headers = [];

    /**
     * Ответ от партнера
     */
    public $partner_response = '';

    /**
     * @var int
     */
    public $partner_response_http_code = 0;

    /**
     * @var mixed
     */
    public $partner_exec_curl_result = false;

    /**
     * @var string
     */
    public $partner_exec_curl_error = '';

    /**
     * Массив с логами
     */
    public $request_log_array = [];

    /**
     * Время начала запроса
     */
    public $time_start_request = 0;

    /**
     * Время конца запроса
     */
    public $time_end_request = 0;

    /**
     * Время затраченное на запрос
     */
    public $request_timeout = 0;

    /**
     * Урл запроса
     */
    public $url_request = '';

    /**
     * Имя файла, содержимое которого использовать в качестве ответа
     */
    public $debug_response_filename = '';

    /**
     * Файл с запросом для подписи
     */
    public $request_xml_file_unsigned = '';

    /**
     * Команда для подписи запроса
     */
    public $cmd_sign = '';

    /**
     * Вывод в консоли при подписи
     */
    public $cmd_sign_response = '';

    /**
     * Результат работы функции addServiceRequest
     */
    public $add_service_request = '';

    /**
     * Команда для отправки запроса
     */
    public $cmd_send = '';

    /**
     * Вывод в консоли при отправке
     */
    public $cmd_send_response = '';

    /**
     * Вывод ошибок при отправке
     */
    public $send_std_error_response = '';

    /**
     * Уникальный идентификатор
     */
    public $uid = '';

    /**
     * Имя подписанного файла
     */
    public $request_xml_file_signed = '';

    /**
     * Имя файла лога отправки
     */
    public $signed_response_filename = '';

    /**
     * Имя провалидированного файла ответа партнера
     */
    public $unsigned_response_filename = '';

    /**
     * Команда для верисикации ответа
     */
    public $cmd_unsign = '';

    /**
     * Ответ в консоли при верификации ответа
     */
    public $cmd_unsign_response = '';

    /**
     * Вывод ошибок при верификации ответа
     */
    public $unsign_std_error_response = '';

    /**
     * Сожержимое схемы для валидации JSON для текущего метода
     */
    public $json_schema_content = '';

    /**
     * Содержимое HTML-описания для текущего метода
     */
    public $html_description = '';

    /**
     * Имя файла схемы для валидации JSON
     */
    public $json_validate_schema_filename = '';

    /**
     * Имя файла с HTML-описанием
     */
    public $method_description_filename = '';

    /**
     * Ответ партнера
     */
    public $request_response = '';

    /**
     * Имя файла с телом письма (только имя, без пути)
     */
    public $filename_letter_basename = '';

    /**
     * Полное имя файла с телом письма (с путем)
     */
    public $filename_letter_full = '';

    /**
     * Имя файла с подписанным телом письма (только имя, без пути)
     */
    public $filename_letter_signed_basename = '';

    /**
     * Полное имя файла с подписанным телом письма (с путем)
     */
    public $filename_letter_signed_full = '';

    /**
     * Имя файла с телом письма (только имя, без пути)
     */
    public $json_partner_request_basename = '';

    /**
     * @var array
     */
    public $emulate_answer_response = [];

    /**
     * Эмулирован ли ответ
     */
    public $is_answer_emulated = 0;

    /**
     * Полное имя файла с телом письма (с путем)
     */
    public $json_partner_request_full = '';

    

    /**
     * ВОзвращает данные для JSON для загрузки примера
     */
    public function getResponseLoadExample()
    {
        $is_error      = false;
        $error_message = '';
        if ($this->hasErrors())
        {
            $error_message = $this->getLastErrorMessage();
            $is_error      = true;
        }

        return [
            'method'           => $this->method,
            'is_error'         => $is_error,
            'error_message'    => $error_message,
            'example_json'     => $this->method_example,
            'json_schema'      => $this->json_schema_content,
            'html_description' => $this->html_description_content,
        ];
    }

    /**
     * Генерирует и возвращает hmac
     */
    public function getHmac()
    {
        global $checked_init_data;
        global $check_model;

        if ($this->hasErrors())
        {
            return false;
        }

        if ($check_model->hasErrors())
        {
            $this->addError(
                'check_model',
                $check_model->getLastErrorMessage()
            );

            return false;
        }

        $param_value = \App\Models\ApiSqlDataModel::getSettingValue('api_secret');
        if ($param_value->result > 0)
        {
            $this->api_secret = $param_value->result_str;
        }

        // Добавлять ли в отладочную информацию секретные данные
        $this->add_in_debug_info_secret_data = 0;
        $param_value                       = \App\Models\ApiSqlDataModel::getSettingValue('add_in_debug_info_secret_data');
        if ($param_value->result > 0)
        {
            $this->add_in_debug_info_secret_data = (int) $param_value->result_str;
        }

        if (!json_validate($this->request))
        {
            $this->addError('request', 'JSON не валиден');
            return false;
        }


        $this->hmac_generate_request = json_encode(json_decode($this->request,true), JSON_UNESCAPED_UNICODE);
        $this->hmac_generate_string = $this->hmac_generate_request.$this->api_secret;
        $this->hmac_generate_string_urlencoded = urlencode($this->hmac_generate_string);
        $this->hmac_generate_string_b64encoded = base64_encode($this->hmac_generate_string);

        if ($this->isShowDebugInfo())
        {
            $this->debug_info['hmac']['generate_request'] = $this->hmac_generate_request;
            if ($this->add_in_debug_info_secret_data)
            {
                $this->debug_info['hmac']['api_secret'] = $this->api_secret;
                $this->debug_info['hmac']['generate_string'] = $this->hmac_generate_string;
                $this->debug_info['hmac']['generate_string_urlencoded'] = $this->hmac_generate_string_urlencoded;
                $this->debug_info['hmac']['generate_string_b64encoded'] = $this->hmac_generate_string_b64encoded;                
            }

        }



        return md5($this->hmac_generate_string);
    }      

    /**
     * Загружает данные для текущего метода
     */
    public function loadCurrentMethod()
    {
        try {

            $this->method = strval($this->method);

            if ($this->hasErrors())
            {
                return false;
            }

            $this->getMethodList();

            if ($this->hasErrors())
            {
                return false;
            }

            $method_found = false;
            foreach ($this->method_list as $method_list_item)
            {
                if ($method_list_item['method_name'] == $this->method)
                {
                    $method_found         = true;
                    $this->current_method = $method_list_item;
                }
            }

            if (!$method_found)
            {
                $this->addError(
                    'method',
                    'Метод не существует'
                );

                return false;
            }

            
        } catch (\Throwable $th) {
            $this->addError(
                'loadCurrentMethod',
                $th->getMessage()
            );

            return false;
        }
        return true;
    }

    /**
     * Загружает примеры для текущего метода
     */
    public function loadCurrentMethodExamples()
    {
        if ($this->hasErrors())
        {
            return false;
        }

        try 
        {

            if (!$this->current_method)
            {
                $this->addError(
                    'current_method',
                    'Текущий метод не задан'
                );
            }

            $get_method_examples_json = ApiSqlDataModel::getMethodExamplesJson($this->current_method['method_key']);
            if ($get_method_examples_json->result < 0)
            {
                $this->addError(
                    'current_method_examples',
                    'Ошибка при получении списока примеров для метода: ' . $get_method_examples_json->result_str
                );

                return false;
            }

            $this->current_method_examples = json_decode($get_method_examples_json->result_str, true);

        } catch (\Throwable $th) {
            $this->addError(
                'loadCurrentMethodExamples',
                $th->getMessage()
            );

            return false;
        }

        return true;
    }

    /**
     * @return mixed
     */
    public function getResponseCurrentMethodSettings()
    {
        $ret = [];
        if ($this->hasErrors())
        {
            $ret['result']     = false;
            $ret['result_str'] = $this->getLastErrorMessage();

            return $ret;
        }

        $ret['result']     = true;
        $ret['result_str'] = 'OK';
        $ret['run_data']   = [
            'current_method'          => $this->current_method,
            'current_method_examples' => $this->current_method_examples,
        ];

        return $ret;
    }

    /**
     * Возвращает список методов в виде массива
     * [
     *      'method_name'=>'method_title'
     *      ...
     * ]
     */
    public function getMethodOptions()
    {
        $options = [];

        if ($this->hasErrors())
        {
            return false;
        }

        $this->getMethodList();

        if ($this->hasErrors())
        {
            return false;
        }

        foreach ($this->method_list as $method_list_item)
        {
            $options[$method_list_item['method_name']] = $method_list_item['title'];
        }

        return $options;
    }

    /**
     * Берет из БД список методов
     */
    public function getMethodList()
    {
        if ($this->hasErrors())
        {
            return false;
        }
        $method_list_json = \App\Models\ApiSqlDataModel::getMethodListJson();

        if ($method_list_json->result < 0)
        {
            $this->addError(
                'method',
                'Не удалось получить список методов с помощью api.get_method_list_json(): ' . $method_list_json->result_str
            );
        }

        $method_list_array = json_decode($method_list_json->result_str, true);

        $this->method_list = $method_list_array;

        return $this->method_list;
    }

    /**
     * Проверяет, нужно ли эмулировать ответ для текущего метода
     */
    public function isCurrentMethodEmulateAnswer()
    {
        if (isset($this->emulate_answer_response[$this->method]['emulate_answer']))
        {
            return $this->emulate_answer_response[$this->method]['emulate_answer'];
        }

        return false;
    }

    /**
     * Проверяет, нужно ли показывать дебаг информацию
     */
    public function isShowDebugInfo()
    {
        global $check_model;
        global $checked_init_data;

        $show_debug_info = config('api.show_debug_info', 0);

        $show_debug_info = (int) $show_debug_info;

        if ($show_debug_info > 1)
        {
            $this->show_debug_info = 1;
        }

        if (!$this->show_debug_info)
        {
            if (($check_model) && ($checked_init_data))
            {
                $param_value = \App\Models\ApiSqlDataModel::getSettingValue('show_debug_info');
                if ($param_value->result > 0)
                {
                    $this->show_debug_info = (int) $param_value->result_str;
                }
            }
        }

        return $this->show_debug_info;
    }

    /**
     * Запускает метод БД при выполнении метода
     *
     *      pre_validate
     *      validate
     *      post_validate
     *      run
     *      post_run
     * @param string $type_name - тип запроса (момент выполнения)
     */
    public function runMethodDBRequestFunc($type_name = '')
    {
        if ($this->hasErrors())
        {
            return false;
        }

        $another_connect = false;

        try 
        {
            foreach ($this->method_request_func_list as $method_request_func_list_item)
            {

                if ($method_request_func_list_item['type_name'] == $type_name)
                {
                    $external_connect_key = intval($method_request_func_list_item['external_connect_key']);
                    if ($external_connect_key > 0)
                    {
                        // Получаем сведения для подключения к БД
                        $get_external_connect_json = \App\Models\ApiSqlDataModel::getExternalConnectJson(
                            $external_connect_key
                        );

                        if ($get_external_connect_json->result < 0)
                        {
                            $this->addError(
                                'external_connect_key',
                                'get_external_connect_json: ' .
                                $get_external_connect_json->result_str
                            );

                            return false;
                        }

                        // Теперь проверяем параметры, которые получили в get_external_connect_json
                        $external_base_data = json_decode($get_external_connect_json->result_str, true)[0];



                        // Добавляем в дебаг информацию (если это определено в конфиге)
                        if ($this->add_in_debug_info_secret_data)
                        {
                            // Добавляем в дебаг информацию
                            $this->debug_info['external_base_data'][$external_connect_key] = $external_base_data;
                        }

                        /*
                        В $external_base_data содержитсся массив
                        {
        "db_host": "172.17.0.1",
        "db_port": "5432",
        "created_on": "2025-09-23T13:50:28.827235",
        "db_database": "api_db",
        "db_password": "j3qq4h7h2v",
        "db_username": "tetis",
        "external_base_key": 1
      }
                        Теперь нужно првоверить валидность данных
                        */
                        if (!isset($external_base_data['db_host']))
                        {
                            $this->addError(
                                'external_base_data',
                                'При выполнении метода ' . $this->method . ' для функции ' .
                                $type_name . ' при подключении к соединению #' . $external_connect_key .
                                ' в настройках подключения к БД отсутствует параметр db_host'
                            );

                            return false;
                        }

                        if (!isset($external_base_data['db_port']))
                        {
                            $this->addError(
                                'external_base_data',
                                'При выполнении метода ' . $this->method . ' для функции ' .
                                $type_name . ' при подключении к соединению #' . $external_connect_key .
                                ' в настройках подключения к БД отсутствует параметр db_port'
                            );

                            return false;
                        }

                        if (!isset($external_base_data['db_database']))
                        {
                            $this->addError(
                                'external_base_data',
                                'При выполнении метода ' . $this->method . ' для функции ' .
                                $type_name . ' при подключении к соединению #' . $external_connect_key .
                                ' в настройках подключения к БД отсутствует параметр db_database'
                            );

                            return false;
                        }

                        if (!isset($external_base_data['db_username']))
                        {
                            $this->addError(
                                'external_base_data',
                                'При выполнении метода ' . $this->method . ' для функции ' .
                                $type_name . ' при подключении к соединению #' . $external_connect_key .
                                ' в настройках подключения к БД отсутствует параметр db_username'
                            );

                            return false;
                        }

                        if (!isset($external_base_data['db_password']))
                        {
                            $this->addError(
                                'external_base_data',
                                'При выполнении метода ' . $this->method . ' для функции ' .
                                $type_name . ' при подключении к соединению #' . $external_connect_key .
                                ' в настройках подключения к БД отсутствует параметр db_password'
                            );

                            return false;
                        }

                        // Проверяем заполненность параметров (не пустые строки)
                        foreach ($external_base_data as $key => $value)
                        {
                            if (trim($value) == '')
                            {
                                $this->addError(
                                    'external_base_data',
                                    'При выполнении метода ' . $this->method . ' для функции ' .
                                    $type_name . ' при подключении к соединению #' . $external_connect_key .
                                    ' в настройках подключения к БД отсутствует параметр ' . $key
                                );

                                return false;
                            }
                        }

                        // Формируем уникальное имя подключения
                        $connection_name = 'database_' . $external_connect_key;

                        // Динамически добавляем новое подключение в конфигурацию
                        Config::set("database.connections.{$connection_name}", [
                            'driver'   => 'pgsql',
                            'host'     => $external_base_data['db_host'],
                            'port'     => $external_base_data['db_port'],
                            'database' => $external_base_data['db_database'],
                            'username' => $external_base_data['db_username'],
                            'password' => $external_base_data['db_password'],
                            'charset'  => 'utf8',
                            'prefix'   => '',
                            'schema'   => 'public',
                            'sslmode'  => 'prefer',
                        ]);

                        // Тестируем подключение
                        try {
                            // Проверяем, что соединение работает
                            DB::connection($connection_name)->getPdo();
                        }
                        catch (\Throwable $th)
                        {
                            $this->addError(
                                'external_base_data',
                                'При выполнении метода ' . $this->method . ' для функции ' .
                                $type_name . ' при подключении к соединению #' . $external_connect_key .
                                ' возникла ошибка: ' . $th->getMessage()
                            );

                            return false;
                        }

                        $another_connect = $connection_name;
                    }

                    // Выполняем метод для тела запроса
                    $run_method = \App\Models\ApiSqlDataModel::runRequestMethod(
                        $this->method,
                        $this->request,
                        $method_request_func_list_item['method_request_func_name'],
                        $another_connect
                    );

                    // Добавляем в дебаг информацию
                    $this->debug_info[$type_name] = $run_method;

                    // return_as_run_data
                    if (intval($method_request_func_list_item['return_as_run_data']))
                    {
                        $this->run_data[$type_name] = $run_method;
                    }

                    if ($run_method->result < 0)
                    {
                        $this->addError(
                            'request',
                            $type_name . ': ' .
                            $run_method->result_str
                        );

                        return false;
                    }
                }
            }
        }
        catch (\Throwable $th)
        {
            $this->addError(
                'method_request_func_list',
                $th->getMessage().' '.$th->getFile().':'.$th->getLine()
            );

            return false;
        }

        return true;
    }

    /**
     * Запускает метод в безопасном режиме
     */
    public function runApiSafe()
    {
        if ($this->hasErrors())
        {
            return false;
        }

        try {
            $this->runApi();
        }
        catch (\Throwable $th)
        {
            $this->addError(
                'runApi',
                $th->getMessage()
            );
        }

        return true;
    }

    /**
     * Запускает метод
     */
    public function runApi()
    {
        global $check_model;

        $this->debug_info['request_body'] = file_get_contents('php://input');
        $this->debug_info['request_url'] = $_SERVER['REQUEST_URI'];
        $this->debug_info['request_method'] = $_SERVER['REQUEST_METHOD'];
        $this->debug_info['post'] = $_POST;
       

        if ($this->hasErrors())
        {
            return false;
        }
        if ($check_model->hasErrors())
        {
            $this->addError(
                'check_model',
                $check_model->getLastErrorMessage()
            );

            return false;
        }

        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
            [
                'method_name'          => $this->method,
                'service_post'         => json_encode($_POST, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT),
                'service_request_body' => file_get_contents('php://input'),
                'service_request_url'  => $_SERVER['REQUEST_URI'],
            ]
        );


        //print_r($set_request_log); exit;

        if ($set_request_log->result < 0)
        {
            $this->addError(
                'set_request_log',
                'set_request_log: ' . $set_request_log->result_str
            );

            return false;
        }

        $this->set_request_log_key = $set_request_log->result;


        // Проверяем наличие метода
        if (!strlen($this->method))
        {
            $this->addError(
                'method',
                'Метод не указан'
            );

            return false;
        }

        // Проверяет наличие метода и загружает его в переменную $this->current_method
        if (!$this->loadCurrentMethod())
        {
            return false;
        }

        // Добавляем в БД сведения о запросе
        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
            [
                'request_log_key' => $this->set_request_log_key,
                'method_key'      => $this->current_method['method_key'],
            ]
        );
        if ($set_request_log->result < 0)
        {
            $this->addError(
                'set_request_log',
                'set_request_log: ' . $set_request_log->result_str
            );

            return false;
        }

        // Доделать проверку на эмуляцию ответа

        $this->request_post = strval($this->request_post);
        $this->request_body = strval($this->request_body);

        $this->debug_info['_request_post'] = $this->request_post;
        $this->debug_info['_request_body'] = $this->request_body;

        if (strlen($this->request_post))
        {
            $this->request = $this->request_post;
        }
        elseif (strlen($this->request_body))
        {
            $this->request = $this->request_body;
        }

        $this->request = trim($this->request);

        $this->debug_info['_request'] = $this->request;

        $this->request = strval($this->request);
        $this->method  = strval($this->method);


        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
            [
                'request_log_key' => $this->set_request_log_key,
                'request'         => $this->request,
            ]
        );

        if ($set_request_log->result < 0)
        {
            $this->addError(
                'set_request_log',
                'set_request_log: ' . $set_request_log->result_str
            );

            return false;
        }




        // Сгенерированный HMAC для текущего запроса
        $this->gen_hmac = $this->getHmac();


        if ($this->hasErrors())
        {
            return false;
        }

        $param_value = \App\Models\ApiSqlDataModel::getSettingValue('enable_hmac');
        if ($param_value->result > 0)
        {
            $this->enable_hmac = $param_value->result_str;
        }
        else
        {
            $this->addError(
                'enable_hmac',
                $param_value->result_str
            );
            return false;
        }

        $this->debug_info['enable_hmac'] = $this->enable_hmac;

        if ($this->enable_hmac)
        {
            $this->debug_info['gen_hmac'] = $this->gen_hmac;
            $this->debug_info['hmac'] = $this->hmac;

            // Проверяем HMAC
            if ($this->gen_hmac != $this->hmac)
            {
                $this->addError(
                    'hmac',
                    'HMAC не совпадает (gen='.$this->gen_hmac.', post=' . $this->hmac . ')'
                );

                return false;
            }   
        }


        // Добавлять ли в отладочную информацию секретные данные
        $this->add_in_debug_info_secret_data = 0;
        $param_value                       = \App\Models\ApiSqlDataModel::getSettingValue('add_in_debug_info_secret_data');
        if ($param_value->result > 0)
        {
            $this->add_in_debug_info_secret_data = (int) $param_value->result_str;
        }


        $this->debug_info['current_method'] = $this->current_method;

        // Это тип ответа (новый формат или eis - для обратной совместимости)
        $this->response_type = $this->current_method['response_type'];

        $get_method_request_func_list_json = \App\Models\ApiSqlDataModel::getMethodRequestFuncListJson($this->current_method['method_key']);
        if ($get_method_request_func_list_json->result < 0)
        {
            $this->addError(
                'current_method',
                'Ошибка при получении списка функций для метода: ' . $get_method_request_func_list_json->result_str
            );

            return false;
        }

        // Добавляем в БД сведения о запросе
        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
            [
                'request_log_key' => $this->set_request_log_key,
                'request'         => $this->request,
            ]
        );

        if ($set_request_log->result < 0)
        {
            $this->addError(
                'set_request_log',
                'set_request_log: ' . $set_request_log->result_str
            );

            return false;
        }

        if ($get_method_request_func_list_json->result == 0)
        {
            $this->method_request_func_list = [];
        }
        else
        {
            $this->method_request_func_list = json_decode($get_method_request_func_list_json->result_str, true);
        }

        // Получили список функций БД для метода
        $this->debug_info['method_request_func_list'] = $this->method_request_func_list;

        // Проверяем - нужно ли для метода требоваться тело запроса
        if (intval($this->current_method['require_request_body']))
        {
            if (!strlen($this->request))
            {
                $this->addError(
                    'request',
                    'Не указано тело запроса'
                );

                return false;
            }

            // Выполняем пре-валидацию если  залана функция pre_validate
            if (!$this->runMethodDBRequestFunc('pre_validate'))
            {
                return false;
            }

            // Если тело запроса должно быть валидным JSON
            if (intval($this->current_method['request_body_must_be_json']))
            {
                // Валидируем JSON
                if (!json_validate($this->request))
                {
                    $this->addError(
                        'request',
                        'Запрос не является валидным JSON'
                    );

                    return false;
                }

                $this->request_array = json_decode($this->request, true);
                

                // Если в api.methods.request_json_schema есть данные, то
                // интерпетируем данные как JSON схему
                if (strlen($this->current_method['request_json_schema']))
                {
                    // Проверяем, что request_json_schema содержит валидный JSON
                    if (!json_validate($this->current_method['request_json_schema']))
                    {
                        $this->addError(
                            'request_json_schema',
                            'api.methods.request_json_schema для метода ' .
                            $this->method .
                            ' не является валидным JSON'
                        );

                        return false;
                    }

                    if (!$this->validateRequestByJsonSchema())
                    {
                        return false;
                    }
                }
            }
        }

        // Проверяем тело запроса (если задана функция типа validate)
        if (!$this->runMethodDBRequestFunc('validate'))
        {
            return false;
        }

        // Выполняем пост-валидацию если  залана функция post_validate
        if (!$this->runMethodDBRequestFunc('post_validate'))
        {
            return false;
        }

        // Выполняем выполнение если  залана функция run
        if (!$this->runMethodDBRequestFunc('run'))
        {
            return false;
        }

        // Выполняем пост-выполнение если  залана функция post_run
        if (!$this->runMethodDBRequestFunc('post_run'))
        {
            return false;
        }

        return true;
    }

    /**
     * Проверяем структуру запросов по JSON-схеме
     */
    public function validateRequestByJsonSchema()
    {
        if ($this->hasErrors())
        {
            return false;
        }

        try {
            $schemaObject = \Swaggest\JsonSchema\Schema::import(
                json_decode($this->current_method['request_json_schema']),
            )->in(
                json_decode($this->request),
            );

            return true;
        }
        catch (\Exception $e)
        {
            $this->addError(
                'schema',
                'JSON validation error: ' . $e->getMessage()
            );

            return false;
        }
    }

    /**
     * Возвращает результат запроса
     */
    public function getApiResponse()
    {
        $ret = [];

        try 
        {
           
           

            // Если есть ошибки, то возвращаем -1 и текст ошибки
            $result     = 1;
            $result_str = 'OK';





            if ('eis' == $this->response_type)
            {

                if ($this->hasErrors())
                {   
                    $ret = [
                        'hmac'     => $this->hmac_output,
                        'response' => [
                            'status'  => 'FAIL',
                            'message' => $this->getLastErrorMessage(),
                        ],
                    ];

                    try 
                    {
                        // Добавляем в БД сведения о запросе
                        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
                            [
                                'request_log_key' => $this->set_request_log_key,
                                'run_result'      => -1,
                                'run_result_str'  => json_encode($ret, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT),
                            ]
                        );
                    } catch (\Throwable $th) {
                        $this->debug_info['set_request_log'][] = $th->getMessage();
                    }

                    // Возвращать ли дебаг информацию
                    if ($this->isShowDebugInfo())
                    {
                        $ret['debug_info'] = $this->debug_info;
                    }

                    return $ret;
                }
                else
                {
                    $response_array = [
                        'status'  => 'SUCCESS',
                        'message' => '',
                    ];

                    

                    // Если был выполнен метод run
                    if (isset($this->run_data['run']))
                    {
                        //print_r();
                        // Предполагаем, что в ответе будет валидный JSON
                        $out_response = $this->run_data['run']->response;


                        if (json_validate($out_response))
                        {
                            $arr = json_decode($out_response, true);
                            $response_array = $response_array + $arr;
                        }
                    }



                    $ret = [
                        'hmac'     => md5(json_encode($response_array, JSON_UNESCAPED_UNICODE) . $this->api_secret),
                        'response' => $response_array ,
                    ];

                    try 
                    {
                        // Добавляем в БД сведения о запросе
                        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog([
                            'request_log_key' => $this->set_request_log_key,
                            'run_result'      => 1,
                            'run_result_str'  => json_encode($ret, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT),
                        ]);
                    } catch (\Throwable $th) {
                        //throw $th;
                        $this->debug_info['set_request_log'][] = $th->getMessage();
                    }

                    // Возвращать ли дебаг информацию
                    if ($this->isShowDebugInfo())
                    {
                        $ret['debug_info'] = $this->debug_info;
                    }

                    return $ret;
                }
            }
            else
            {
                // Возвращать ли дебаг информацию
                if ($this->isShowDebugInfo())
                {
                    $ret['debug_info'] = $this->debug_info;
                }

                if ($this->hasErrors())
                {
                    $ret['run_data']   = $this->run_data;
                    $ret['result']     = -1;
                    $ret['result_str'] = $this->getLastErrorMessage();

                    try 
                    {
                        // Добавляем в БД сведения о запросе
                        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
                            [
                                'request_log_key' => $this->set_request_log_key,
                                'run_result'      => $ret['result'],
                                'run_result_str'  => json_encode($ret, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT),
                            ]
                        );
                    } catch (\Throwable $th) {
                        //throw $th;
                    }

                    return $ret;
                }
                else
                {
                    $ret['run_data']   = $this->run_data;
                    $ret['result']     = 1;
                    $ret['result_str'] = 'OK';

                    try {
                        // Добавляем в БД сведения о запросе
                        $set_request_log = \App\Models\ApiSqlDataModel::setRequestLog(
                            [
                                'request_log_key' => $this->set_request_log_key,
                                'run_result'      => $ret['result'],
                                'run_result_str'  => json_encode($ret, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT),
                            ]
                        );
                    } catch (\Throwable $th) {
                        
                    }

                    return $ret;
                }
            }

         //code...
        } catch (\Throwable $th) {
            $ret['result']     = -1;
            $ret['result_str'] = $th->getMessage();
        }

        return $ret;
    }
}
