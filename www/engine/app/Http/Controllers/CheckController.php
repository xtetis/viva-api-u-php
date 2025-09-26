<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\View;

class CheckController extends Controller
{
    public static function all()
    {
        $check_model = new \App\Models\CheckModel();
        $check_model->checkInitData();

        return View::make('check.all', [
            'check_model' => $check_model
        ]);

        /*
        $host = env('API_DB_HOST', 'default'); // Minimal env() call
        $host = env('API_DB_HOST', '');
        $port = env('API_DB_PORT', '5432');
        $database = env('API_DB_DATABASE', 'laravel');
        $username = env('API_DB_USERNAME', 'root');
        $password = env('API_DB_PASSWORD', '');

        if (!strlen($host))
        {
            throw new \Exception('Env API_DB_HOST is empty');
        }

        if (!strlen($port))
        {
            throw new \Exception('Env API_DB_PORT is empty');
        }

        if (!strlen($database))
        {
            throw new \Exception('Env API_DB_DATABASE is empty');
        }

        if (!strlen($username))
        {
            throw new \Exception('Env API_DB_USERNAME is empty');
        }

        if (!strlen($password))
        {
            throw new \Exception('Env API_DB_PASSWORD is empty');
        }

        // Эти переменные окружения прописаны как параметры подключения к
        // api_db потому пытаемся выполнить подключение к БД api_db
        // И если подключение прошло неуспешно - выводим ошибку
        try {
            \DB::connection('api_db')->getPdo();
        } catch (\Exception $e) {
            throw new \Exception('Error connect to database: ' . $e->getMessage());
        }

        // Получаем текущую версию веб приложения
        $currentWebVersion = config('api.current_web_version', 0);
        if (!$currentWebVersion)
        {
            throw new \Exception('Error get current web version from config');
        }
        // Получаем соответствующую версию БД для текущей версии веб приложения
        // Это массив соответствий
        $db_version_matches = config('api.versions_web_db', []);
        if (empty($db_version_matches))
        {
            throw new \Exception('Error get versions_web_db from config');
        }

        // Если для текущей версии веб приложения нет соответствия версии БД - ошибка
        if (!isset($db_version_matches[$currentWebVersion]))
        {
            throw new \Exception('Error get db version for current web version from config');
        }

        // Версия БД, которая должна быть для текущей версии веб приложения
        $required_db_version = $db_version_matches[$currentWebVersion];

        $current_db_version = 0;
        // Если подключение успешно - проверяем версию функционала API БД
        try
        {
            $version = \App\Models\ApiSqlDataModel::getDbApiVersion();
            $current_db_version = isset($version->result) ? (int)$version->result : 0;
        }
        catch (\Exception $e)
        {
            throw new \Exception('Error get version: ' . $e->getMessage());
        }



        if (!$current_db_version)
        {
            
            throw new \Exception('Error get current db version from database');
        }

        if ($current_db_version != $required_db_version)
        {
            throw new \Exception('Error db version ' . $current_db_version . ' is not match required version ' . $required_db_version);
        }




        // Делаем редирект на /test/api для перехода на тестовый контур
        return redirect('/test/api');
        */
    }
}