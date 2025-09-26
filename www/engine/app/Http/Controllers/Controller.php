<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\View;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{


    /**
     * Возвращает страницу логов
     */
    public function logs()
    {
        return View::make('page.logs', [
            'model' => new \App\Models\RequestModel,
        ]);
    }

    /**
     * Возвращает страницу настроек
     */
    public function settings()
    {
        return View::make('page.settings', [
            'model' => new \App\Models\RequestModel,
        ]);
    }
}
