<?php

namespace App\Models;

use Illuminate\Support\Facades\Validator;
use App\Models\FileServiceModel;
use App\Models\PdfModel;
use App\Models\BaseModel;
use App\Models\SqlDataModel;

global $checked_init_data;

class HttpAuthModel extends BaseModel
{

    public static function loginHttp()
    {
        global $checked_init_data;

        $app_enable_http_base_auth = env('APP_ENABLE_HTTP_BASE_AUTH', '');   
        $http_base_login = env('HTTP_BASE_LOGIN', ''); 
        $http_base_password = env('HTTP_BASE_PASSWORD', ''); 

        $app_enable_http_base_auth = intval($app_enable_http_base_auth);
        $http_base_login = trim($http_base_login);
        $http_base_password = trim($http_base_password);


        if ($app_enable_http_base_auth)
        {
            // Проверяем в сессии наличие параметра auth_request для Laravel
            if (!session()->has('auth_request'))
            {
                if (
                    (!isset($_SERVER['PHP_AUTH_USER'])) ||
                    (!isset($_SERVER['PHP_AUTH_PW'])) ||
                    ($_SERVER['PHP_AUTH_USER'] != $http_base_login) ||
                    (md5($_SERVER['PHP_AUTH_PW']) != $http_base_password)
                )
                {
                
                    // Если авторизация не прошла - удаляем сессию
                    session()->forget('auth_requests');

                    unset($_SERVER['PHP_AUTH_USER']);
                    unset($_SERVER['PHP_AUTH_PW']);
                    header('WWW-Authenticate: Basic realm=""');
                    header('HTTP/1.0 401 Unauthorized');
                    echo 'Необходима авторизация';
                    exit;
                }
                else
                {
                    session()->put('auth_request', 1);
                }
            }

        }
    }  
}
