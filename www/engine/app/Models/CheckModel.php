<?php

namespace App\Models;

use App\Models\BaseModel;
use Illuminate\Support\Facades\DB;

class CheckModel extends BaseModel
{
    /**
     * Список для проверки для инициализации приложения
     */
    public $init_check_list = [
        'app_enable_http_base_auth'                    => [
            'title'      => 'Включить ли базовую авторизацию для тестовых страниц (переменная окружения APP_ENABLE_HTTP_BASE_AUTH, если включена то обязательными являются переменные окружения HTTP_BASE_LOGIN и HTTP_BASE_PASSWORD)',
            'value'      => '',
            'show_value' => true,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'app_scheme'                                   => [
            'title'      => 'Схема (переменная окружения APP_SCHEME)',
            'value'      => '',
            'show_value' => true,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'api_db_host'                                  => [
            'title'      => 'Хост БД API (переменная окружения API_DB_HOST)',
            'value'      => '',
            'show_value' => false,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'api_db_port'                                  => [
            'title'      => 'Порт БД API (переменная окружения API_DB_PORT)',
            'value'      => '',
            'show_value' => false,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'api_db_database'                              => [
            'title'      => 'БД API (переменная окружения API_DB_DATABASE)',
            'value'      => '',
            'show_value' => false,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'api_db_username'                              => [
            'title'      => 'Пользователь БД API (переменная окружения API_DB_USERNAME)',
            'value'      => '',
            'show_value' => false,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'api_db_password'                              => [
            'title'      => 'Пароль БД API (переменная окружения API_DB_PASSWORD)',
            'value'      => '',
            'show_value' => false,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'check_db_connection'                          => [
            'title'      => 'Подключение к БД API',
            'value'      => '',
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'current_web_version'                          => [
            'title'      => 'Версия веб приложения',
            'value'      => 0,
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'versions_web_db'                              => [
            'title'      => 'Соответствие версий веб приложения и БД',
            'value'      => [],
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'required_db_version'                          => [
            'title'      => 'Требуемая версия БД',
            'value'      => 0,
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'current_db_version'                           => [
            'title'      => 'Текущая версия БД',
            'value'      => 0,
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'web_version_exists_in_versions_web_db'        => [
            'title'      => 'Версия веб приложения существует в списке соответствий',
            'value'      => 0,
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'current_db_version_equal_required_db_version' => [
            'title'      => 'Текущая версия БД равна требуемой',
            'value'      => 0,
            'show_value' => 1,
            'checked'    => 0,
            'prepared'   => 0, // Проводилась проверка
        ],
        'check_db_params'                              => [
            'title'      => 'Проверка параметров БД',
            'value'      => 0,
            'show_value' => 1,
            'checked'    => 0,
            'hint'       => 'Проверяет функционал в API БД с помощью функции api.check_db_params()',
            'prepared'   => 0, // Проводилась проверка
        ],

    ];
    /**
     * Версия веб приложения
     */
    public $current_web_version = 0;

    /**
     * Список соответствий версий веб приложения и БД
     */
    public $versions_web_db = [];

    /**
     * Существует ли соответствие текущей версии веб приложения и БД
     */
    public $exists_matches_current_web_version = false;

    /**
     * Требуемая версия БД
     */
    public $required_db_version = 0;

    /**
     * Текущая версия БД
     */
    public $current_db_version = 0;

    /**
     * @var mixed
     */
    public $checked_init_data = false;

    /**
     * Проверяет информацию для инициализации приложения
     */
    public function checkInitData()
    {

        $app_enable_http_base_auth = env('APP_ENABLE_HTTP_BASE_AUTH', '');
        $this->init_check_list['app_enable_http_base_auth']['prepared'] = 1;

        // Проверка заполненности переменной окружения API_DB_HOST
        if (!strlen($app_enable_http_base_auth))
        {
            $this->addError(
                'app_enable_http_base_auth',
                'Переменная окружения APP_ENABLE_HTTP_BASE_AUTH пустая'
            );

            return false;
        }

        if (!is_numeric($app_enable_http_base_auth))
        {
            $this->addError(
                'app_enable_http_base_auth',
                'Переменная окружения APP_ENABLE_HTTP_BASE_AUTH не является числом'
            );

            return false;
        }

        $app_enable_http_base_auth = intval($app_enable_http_base_auth);

        $this->init_check_list['app_enable_http_base_auth']['value']   = intval($app_enable_http_base_auth);
        $this->init_check_list['app_enable_http_base_auth']['checked'] = 1;

        if ($app_enable_http_base_auth)
        {
            $http_base_login    = env('HTTP_BASE_LOGIN', '');
            $http_base_password = env('HTTP_BASE_PASSWORD', '');

            $http_base_login    = trim($http_base_login);
            $http_base_password = trim($http_base_password);

            // Проверка заполненности переменной окружения HTTP_BASE_LOGIN и HTTP_BASE_PASSWORD
            if (!strlen($http_base_login) || !strlen($http_base_password))
            {
                $this->init_check_list['app_enable_http_base_auth']['checked'] = 0;

                $this->addError(
                    'http_base_login',
                    'Ввиду того, что включена базовая авторизация (APP_ENABLE_HTTP_BASE_AUTH = 1), переменная окружения HTTP_BASE_LOGIN или HTTP_BASE_PASSWORD пустая (должны быть заполнены оба)'
                );

                return false;
            }
        }

        // -----------------------------------------------------------

        // -----------------------------------------------------------
        $this->init_check_list['app_scheme']['prepared'] = 1;
        $app_scheme = env('APP_SCHEME', '');

        // Проверка заполненности переменной окружения API_DB_HOST
        if (!strlen($app_scheme))
        {
            $this->addError(
                'app_scheme',
                'Переменная окружения APP_SCHEME пустая'
            );

            return false;
        }

        if (!in_array($app_scheme, ['http', 'https']))
        {
            $this->addError(
                'app_scheme',
                'Переменная окружения APP_SCHEME должна быть равна http или https'
            );

            return false;
        }

        $this->init_check_list['app_scheme']['value']   = $app_scheme;
        $this->init_check_list['app_scheme']['checked'] = 1;


        // -----------------------------------------------------------
        $this->init_check_list['api_db_host']['prepared'] = 1;

        $host = env('API_DB_HOST', '');

        // Проверка заполненности переменной окружения API_DB_HOST
        if (!strlen($host))
        {
            $this->addError(
                'api_db_host',
                'Переменная окружения API_DB_HOST пустая'
            );

            return false;
        }

        $this->init_check_list['api_db_host']['value']   = $host;
        $this->init_check_list['api_db_host']['checked'] = 1;


        // -----------------------------------------------------------
        $this->init_check_list['api_db_port']['prepared'] = 1;

        $port = env('API_DB_PORT', '');

        // Проверка заполненности переменной окружения API_DB_PORT
        if (!strlen($port))
        {
            $this->addError(
                'api_db_port',
                'Переменная окружения API_DB_PORT пустая'
            );

            return false;
        }

        $this->init_check_list['api_db_port']['value']   = $port;
        $this->init_check_list['api_db_port']['checked'] = 1;


        // -----------------------------------------------------------
        $this->init_check_list['api_db_database']['prepared'] = 1;

        // Проверка заполненности переменной окружения API_DB_DATABASE
        $database = env('API_DB_DATABASE', '');

        if (!strlen($database))
        {
            $this->addError(
                'api_db_database',
                'Переменная окружения API_DB_DATABASE пустая'
            );

            return false;
        }

        $this->init_check_list['api_db_database']['value']   = $database;
        $this->init_check_list['api_db_database']['checked'] = 1;



        // -----------------------------------------------------------
        $this->init_check_list['api_db_username']['prepared'] = 1;
        $username = env('API_DB_USERNAME', '');

        // Проверка заполненности переменной окружения API_DB_USERNAME
        if (!strlen($username))
        {
            $this->addError(
                'api_db_username',
                'Переменная окружения API_DB_USERNAME пустая'
            );

            return false;
        }

        $this->init_check_list['api_db_username']['value']   = $username;
        $this->init_check_list['api_db_username']['checked'] = 1;




        // -----------------------------------------------------------
        $this->init_check_list['api_db_password']['prepared'] = 1;
        $password = env('API_DB_PASSWORD', '');

        // Проверка заполненности переменной окружения API_DB_PASSWORD
        if (!strlen($password))
        {
            $this->addError(
                'api_db_password',
                'Переменная окружения API_DB_PASSWORD пустая'
            );

            return false;
        }

        $this->init_check_list['api_db_password']['value']   = $password;
        $this->init_check_list['api_db_password']['checked'] = 1;





        // -----------------------------------------------------------
        $this->init_check_list['check_db_connection']['prepared'] = 1;
        // Эти переменные окружения прописаны как параметры подключения к
        // api_db потому пытаемся выполнить подключение к БД api_db
        // И если подключение прошло неуспешно - выводим ошибку
        try {
            DB::connection('api_db')->getPdo();
        }
        catch (\Exception $e)
        {
            $this->addError(
                'check_db_connection',
                'Ошибка подключения к БД: ' . $e->getMessage()
            );
        }

        $this->init_check_list['check_db_connection']['value']   = 'Подключено';
        $this->init_check_list['check_db_connection']['checked'] = 1;





        // -----------------------------------------------------------
        $this->init_check_list['current_web_version']['prepared'] = 1;
        // Версия веб приложения
        $this->current_web_version = config('api.current_web_version', 0);
        if (!is_numeric($this->current_web_version))
        {
            $this->init_check_list['current_web_version']['value']   = 'Не определено';
            $this->init_check_list['current_web_version']['checked'] = 0;

            $this->addError(
                'current_web_version',
                'Версия веб приложения не определена'
            );

            return false;

        }

        $this->init_check_list['current_web_version']['value']   = $this->current_web_version;
        $this->init_check_list['current_web_version']['checked'] = 1;






        // -----------------------------------------------------------
        $this->init_check_list['versions_web_db']['prepared'] = 1;
        // Версии веб приложения и БД
        $this->versions_web_db = config('api.versions_web_db', []);
        if (!is_array($this->versions_web_db))
        {
            $this->init_check_list['versions_web_db']['value']   = 'Не определено';
            $this->init_check_list['versions_web_db']['checked'] = 0;

            $this->addError(
                'versions_web_db',
                'Версии веб приложения и БД не определены'
            );

            return false;

        }

        $this->init_check_list['versions_web_db']['value']   = $this->versions_web_db;
        $this->init_check_list['versions_web_db']['checked'] = 1;





        // -----------------------------------------------------------
        $this->init_check_list['web_version_exists_in_versions_web_db']['prepared'] = 1;
        //print_r();
        // Проверка существования соответствия текущей версии веб приложения и БД
        if (!isset($this->versions_web_db[$this->current_web_version]))
        {
            $this->init_check_list['web_version_exists_in_versions_web_db']['value']   = 'Не определено';
            $this->init_check_list['web_version_exists_in_versions_web_db']['checked'] = 0;

            $this->addError(
                'web_version_exists_in_versions_web_db',
                'Версия веб приложения не определена в списке поддерживаемых версий'
            );

            return false;
        }

        $this->exists_matches_current_web_version                                  = true;
        $this->init_check_list['web_version_exists_in_versions_web_db']['value']   = $this->versions_web_db[$this->current_web_version];
        $this->init_check_list['web_version_exists_in_versions_web_db']['checked'] = 1;




        // -----------------------------------------------------------
        $this->init_check_list['required_db_version']['prepared'] = 1;
        // Требуемая версия БД
        $this->required_db_version = $this->versions_web_db[$this->current_web_version];
        $this->required_db_version = intval($this->required_db_version);
        if (!$this->required_db_version)
        {
            $this->init_check_list['required_db_version']['value']   = 'Не определено';
            $this->init_check_list['required_db_version']['checked'] = 0;

            $this->addError(
                'required_db_version',
                'Требуемая версия БД не определена'
            );

            return false;
        }

        $this->init_check_list['required_db_version']['value']   = $this->required_db_version;
        $this->init_check_list['required_db_version']['checked'] = 1;





        // -----------------------------------------------------------
        $this->init_check_list['current_db_version']['prepared'] = 1;
        $this->current_db_version = 0;
        // Если подключение успешно - проверяем версию функционала API БД
        try
        {
            $version = \App\Models\ApiSqlDataModel::getDbApiVersion();
            //print_r($version); exit;
            $this->current_db_version = isset($version->result) ? (int) $version->result : 0;
        }
        catch (\Exception $e)
        {
            $this->init_check_list['current_db_version']['value']   = 'Не определено';
            $this->init_check_list['current_db_version']['checked'] = 0;

            $this->addError(
                'current_db_version',
                'Версия функционала API БД не определена: ' . $e->getMessage()
            );

            return false;
        }

        $this->init_check_list['current_db_version']['value']   = $this->current_db_version;
        $this->init_check_list['current_db_version']['checked'] = 1;

        if (!$this->current_db_version)
        {
            $this->init_check_list['current_db_version']['value']   = 'Не определено';
            $this->init_check_list['current_db_version']['checked'] = 0;

            $this->addError(
                'current_db_version',
                'Версия функционала API БД не определена'
            );

            return false;
        }






        // -----------------------------------------------------------
        $this->init_check_list['current_db_version_equal_required_db_version']['prepared'] = 1;
        // Если версии не совпадают - выдаем предупреждение
        if ($this->current_db_version != $this->required_db_version)
        {
            $this->init_check_list['current_db_version_equal_required_db_version']['value']   = 'Не определено';
            $this->init_check_list['current_db_version_equal_required_db_version']['checked'] = 0;

            $this->addError(
                'current_db_version_equal_required_db_version',
                'Версия функционала API БД не соответствует требуемой'
            );

            return false;
        }

        $this->init_check_list['current_db_version_equal_required_db_version']['value']   = 1;
        $this->init_check_list['current_db_version_equal_required_db_version']['checked'] = 1;







        // -----------------------------------------------------------
        $this->init_check_list['check_db_params']['prepared'] = 1;
        // Проверяем функционал в БД
        try
        {
            $check_db_params = \App\Models\ApiSqlDataModel::checkDbParams();
        }
        catch (\Exception $e)
        {
            $this->init_check_list['check_db_params']['value']   = $e->getMessage();
            $this->init_check_list['check_db_params']['checked'] = 0;

            $this->addError(
                'check_db_params',
                'Ошибки при проверке функционала API БД: ' . $e->getMessage()
            );

            return false;
        }

        if ($check_db_params->result < 0)
        {
            $this->init_check_list['check_db_params']['value']   = $check_db_params->result_str;
            $this->init_check_list['check_db_params']['checked'] = 0;

            $this->addError(
                'check_db_params',
                'Ошибки при проверке функционала API БД: ' . $check_db_params->result_str
            );

            return false;
        }

        $this->init_check_list['check_db_params']['value']   = $check_db_params->result_str;
        $this->init_check_list['check_db_params']['checked'] = 1;
        // -----------------------------------------------------------



        $this->checked_init_data = true;

        return true;
    }

    /**
     * Тут форомируем отчет о проверке API/БД к работе по массиву init_check_list
     */
    public function getResponse()
    {

        return $this->init_check_list;

    }
}
