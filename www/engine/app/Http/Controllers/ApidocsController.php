<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\View;

class ApidocsController extends Controller
{

    /**
     * Страница с документацией
     */
    public static function main()
    {

        return View::make('apidocs.main', [
            
        ]);

    }
}