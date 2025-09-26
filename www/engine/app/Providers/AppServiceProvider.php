<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

global $checked_init_data;
global $check_model;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {

        $scheme = 'https';

        $conf_end_scheme = env('APP_SCHEME','');

        if (($conf_end_scheme) && (in_array($conf_end_scheme,['http','https'])))
        {
            $scheme = $conf_end_scheme;
        }

        URL::forceScheme($scheme);   
        
    }
}
