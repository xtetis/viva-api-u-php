<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\View;
use Illuminate\Routing\Controller as BaseController;

class LogController extends BaseController
{


    /**
     * Возвращает страницу логов
     */
    public function logs()
    {
        $get_request_log_list_json = \App\Models\ApiSqlDataModel::getRequestLogListJson();

        if ($get_request_log_list_json->result < 0)
        {
            user_error($get_request_log_list_json->result_str);
        }

        $params = [];

        $params_get = [
            'show_log_fields',
        ];
        foreach ($params_get as $value)
        {
            $param_value = \App\Models\ApiSqlDataModel::getSettingValue($value);
            if ($param_value->result < 0)
            {
                user_error('Параметр ' . $value . ': ' . $param_value->result_str);
            }
            else
            {
                $params[$value] = $param_value->result_str;
            }
        }


        $request_log_list = json_decode($get_request_log_list_json->result_str, true);
        return View::make('logs.index', [
            'request_log_list' => $request_log_list,
            'params' => $params
        ]);
    }
}
