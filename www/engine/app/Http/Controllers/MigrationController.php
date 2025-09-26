<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\View;

class MigrationController extends Controller
{

    /**
     * Страница списка SQL скриптов для миграции
     */
    public static function sql()
    {

        return View::make('mirgation.sql', [
            
        ]);

    }
}