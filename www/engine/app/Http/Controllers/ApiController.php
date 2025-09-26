<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Facades\Response;
use Illuminate\Routing\Controller as BaseController;

/**
 * Контроллер для обработки запросов API
 */
class ApiController extends BaseController
{
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
    public function runMethod($method = '')
    {
        $request = request();

        // Если $method пустой - вычитываем значение POST параметра method
        if (strlen($method) == 0) {
            $method = strval($request->input('method', ''));
        }

        // $request_post берем из POST параметра request
        $request_post = strval($request->input('request', ''));

        // $request_body берем из тела запроса
        $request_body = $request->getContent();

        

        $model               = new \App\Models\RequestModel();
        $model->method       = $method;
        $model->request_post = $request_post;
        $model->request_body = $request_body;
        $model->hmac = strval($request->input('hmac', ''));
        $model->runApiSafe(); 
        
        $response_array = $model->getApiResponse();
        $response = response()->json(
            $response_array , 
            200, 
            ['Content-Type' => 'application/json', 'Charset' => 'utf-8'],
            JSON_UNESCAPED_UNICODE
        );
        return $response;

    }

}
