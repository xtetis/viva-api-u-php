<?php

namespace App\Models;

use Illuminate\Support\Facades\DB;

class ApiSqlDataModel
{
    /**
     * Возвращает версию функционала API БД
     */
    public static function getDbApiVersion(
        )
        {
            
            $result = DB::connection('api_db')->select(
                'select * FROM api.get_version()',
            );
    
            $row = [];
    
            if (!empty($result))
            {
                $row = $result[0];
            }
    
            return $row;
    }

    /**
     * Проверяет функционал в API БД
     */
    public static function checkDbParams(
        )
        {
            
            $result = DB::connection('api_db')->select(
                'select * FROM api.check_db_params()',
            );
    
            $row = [];
    
            if (!empty($result))
            {
                $row = $result[0];
            }
    
            return $row;
    }

    /**
     * Возвращает список методов в json
     */
    public static function getMethodListJson(
    )
    {
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.get_method_list_json()',
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }


    
    /**
     * Возвращает значение параметра
     */
    public static function getSettingValue(
        $param_name = ''
    )
    {
        $param_name = strval($param_name);
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.get_param(?)',
            [$param_name],
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }


    
    /**
     * Возвращает список примеров для метода в виде JSON
     */
    public static function getMethodExamplesJson(
        $method_key = 0
    )
    {
        $method_key = intval($method_key);
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.get_method_examples_json(?)',
            [$method_key],
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }



    /**
     * 
     * 
     * api.run_request_method(_method character varying, _request character varying, _run_method character varying)
     */
    public static function runRequestMethod(
        $method = '',
        $request = '',
        $run_method = '',
        $another_connect = false
    )
    {
        $request = strval($request);
        $request = strval($request);
        $run_method = strval($run_method);

        $connect_name = 'api_db';
        if ($another_connect)
        {
            $connect_name = $another_connect;
        }
        
        $result = DB::connection($connect_name)->select(
            'select * FROM api.run_request_method(?, ?, ?)',
            [$method, $request, $run_method],
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }
    



    
    /**
     * Возвращает подключение к БД
     */
    public static function getExternalConnectJson(
        $external_connect_key = 0
    )
    {
        $external_connect_key = intval($external_connect_key);
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.get_external_connect_json(?)',
            [$external_connect_key],
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }



    
    /**
     * Возвращает список функций БД для метода
     */
    public static function getMethodRequestFuncListJson(
        $method_key = 0
    )
    {
        $method_key = intval($method_key);
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.get_method_request_func_list_json(?)',
            [$method_key],
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }



    
    /**
     * Устанавливает запись в журнал о запросе
     * 
     * @param array $data_array - массив с данными
     */
    public static function setRequestLog(
        array $data_array = []
    )
    {
        /*
        if (!count($data_array))
        {
            user_error('Пустой массив');
        }
        */
        $json = json_encode($data_array);
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.set_request_log(?)',
            [$json],
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }




    /**
     * Возвращает список последних запросов в JSON
     */
    public static function getRequestLogListJson()
    {
        
        $result = DB::connection('api_db')->select(
            'select * FROM api.get_request_log_list_json()',
        );

        $row = [];

        if (!empty($result))
        {
            $row = $result[0];
        }

        return $row;
    }
}
