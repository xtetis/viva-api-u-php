<?php

global $checked_init_data;
global $check_model;

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Controllers\TestController;
use App\Http\Controllers\CheckController;
use App\Http\Controllers\MigrationController;
use App\Http\Controllers\LogController;

$checked_init_data = false;
try {
    $check_model = new \App\Models\CheckModel();
    $checked_init_data =$check_model->checkInitData();
} catch (\Throwable $th) {
    die($th->getMessage());
}



// Если главная страница - сначала проверяем настройки
// для POST запросов / нужно предусмотреть обработку method как POST параметра
Route::get('/', function ()
{
    global $checked_init_data;

    if (!$checked_init_data)
    {
        return redirect('/check_api');
    }
    else
    {
        return redirect('/test/api');
    }

    
});

// Проверочная страница
Route::any('/check_api', function ()
{
    // Для доступа к странице нужно на бою авторизироваться (базово через HTTP Basic Auth)
    \App\Models\HttpAuthModel::loginHttp();

    global $checked_init_data;

    $check_controller = new \App\Http\Controllers\CheckController();
    return $check_controller->all();
})->name('check_api');


// Страница списка SQL скриптов для миграции
Route::any('/migration/sql', function ()
{
    // Для доступа к странице нужно на бою авторизироваться (базово через HTTP Basic Auth)
    \App\Models\HttpAuthModel::loginHttp();

    global $checked_init_data;

    $migration_controller = new \App\Http\Controllers\MigrationController();
    return $migration_controller->sql();
})->name('migration_sql');




// Страница документации API
Route::any('/apidocs/main', function ()
{
    // Для доступа к странице нужно на бою авторизироваться (базово через HTTP Basic Auth)
    \App\Models\HttpAuthModel::loginHttp();

    global $checked_init_data;

    $apidocs_controller = new \App\Http\Controllers\ApidocsController();
    return $apidocs_controller->main();
})->name('apidocs_main');


    
// Тестовая страница API партнера
Route::any('/test/api', function ()
{
    // Для доступа к странице нужно на бою авторизироваться (базово через HTTP Basic Auth)
    \App\Models\HttpAuthModel::loginHttp();

    global $checked_init_data;

    if (!$checked_init_data)
    {
        return redirect('/check_api');
    }

    $test_controller = new \App\Http\Controllers\TestController();
    return $test_controller->api();
})->name('test_api');


// Страница загрузки настроек метода
Route::any('/test/ajax_load_method_settings', function ()
{      
    global $checked_init_data;



    if (!$checked_init_data)
    {
        return redirect('/check_api');
    }

    $test_controller = new \App\Http\Controllers\TestController();
    return $test_controller->loadMethodSettings();
})->name('test.ajax_load_method_settings');


// Страница получения HMAC
Route::any('/test/ajax_get_hmac', function ()
{
    global $checked_init_data;

    if (!$checked_init_data)
    {
        return redirect('/check_api');
    }

    $test_controller = new \App\Http\Controllers\TestController();
    return $test_controller->getHmac();
})->name('test.ajax_get_hmac');




// Это API метод. Тут мы не проверяем настройки, а проверяем их 
// уже внутри самого запроса и отдаем как JSON
Route::any('/api/{method}', function ($method)
{
    $api_controller = new \App\Http\Controllers\ApiController();
    return $api_controller->runMethod($method);
})->where(['method' => '[a-z_0-9]+']);



    
// Страница логов
Route::any('/logs', function ()
{
    // Для доступа к странице нужно на бою авторизироваться (базово через HTTP Basic Auth)
    \App\Models\HttpAuthModel::loginHttp();

    global $checked_init_data;

    if (!$checked_init_data)
    {
        return redirect('/check_api');
    }

    $log_controller = new \App\Http\Controllers\LogController();
    return $log_controller->logs();
})->name('logs');


/*
// Загрузка примера по AJAX запроса к партнеру
Route::any('/test/api_load_example', [TestController::class, 'apiLoadExample'])
    ->name('api_load_example');




Route::get('/settings', [Controller::class, 'settings'])->name('settings');

*/
