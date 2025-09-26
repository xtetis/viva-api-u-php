<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Facades\Response;
use Illuminate\Routing\Controller as BaseController;

class TestController extends BaseController
{

    /**
     * Загружает пример для метода API с партнером
     */
    public function loadMethodSettings()
    {
        $ret           = [];
        $ret['result'] = false;

        try 
        {
            // Request $request
            $request = request();

            $model         = new \App\Models\RequestModel();
            $model->method = $request->input('method', '');
            // Загружает данные для текущего метода
            $model->loadCurrentMethod();
            // Загружает примеры для текущего метода
            $model->loadCurrentMethodExamples();
            // Сормируем ответ для AJAX запроса - настройки текущего метода
            $ret = $model->getResponseCurrentMethodSettings();


            
        } catch (\Throwable $th) {
            $ret['result_str'] = $th->getMessage();
        }

        return $ret;
    }

    /**
     * @param  Request $request
     * @return mixed
     */
    public function index(Request $request)
    {
        $method = strval($request->input('method', ''));

        return $this->runMethod($method, $request);
    }

    /**
     * @param string  $method
     * @param Request $request
     */
    public function runMethod(
        string  $method,
        Request $request
    )
    {
        $request_post = $request->input('request', '');
        $request_body = $request->getContent();

        $model               = new \App\Models\RequestModel();
        $model->method       = $method;
        $model->request_post = $request_post;
        $model->request_body = $request_body;
        $model->runApi();

        header('Content-Type: application/json; charset=utf-8');

        return response()->json(
            $model->getApiResponse(),
            200,
            ['Content-Type' => 'application/json', 'Charset' => 'utf-8'],
            JSON_UNESCAPED_UNICODE
        );

        //return response()->json($model->getApiResponse(), 200, ['Content-Type' => 'application/json;charset=UTF-8', 'Charset' => 'utf-8']);
    }

    /**
     * Возвращает тестовую страницу API обращения к партнеру
     */
    public function api()
    {
        $model               = new \App\Models\RequestModel();
        $method_list_options = $model->getMethodOptions();
        if ($model->hasErrors())
        {
            user_error($model->getLastErrorMessage());
        }

        $params = [];

        $params_get = [
            'enable_hmac',
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

        return View::make('test.api', [
            'params'              => $params,
            'method_list_options' => $method_list_options,
        ]);
    }

    /**
     * Возвращает hmac
     */
    public function getHmac()
    {
        try {
            $request = request();

            $model          = new \App\Models\RequestModel();
            

            $model->request = strval($request->input('request', ''));
            $hmac           = $model->getHmac();
            if ($model->hasErrors())
            {
                $ret['result']     = false;
                $ret['result_str'] = $model->getLastErrorMessage();
            }
            else
            {
                $ret['result']     = true;
                $ret['result_str'] = $hmac;
                $ret['secret'] = $model->api_secret;
                $ret['request'] = json_encode($model->request_array, JSON_UNESCAPED_UNICODE);
            }
        }
        catch (\Exception $e)
        {
            $ret['result']     = false;
            $ret['result_str'] = $e->getMessage();
        }

        return $ret;
    }

    /**
     * Возвращает страницу настроек
     */
    public function settings()
    {
        /*
        return View::make('page.settings', [
            'model' => new \App\Models\PartnerRequestModel,
        ]);
        */
    }

    /**
     * Возвращает страницу логов
     */
    public function logs()
    {
        /*
        return View::make('page.logs', [
            'model' => new \App\Models\PartnerRequestModel,
        ]);
        */
    }
}
