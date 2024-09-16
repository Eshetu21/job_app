<?php

use App\Http\Middleware\AdminCheck;
use App\Http\Middleware\canaddadmins;
use App\Http\Middleware\CanDeleteAdmin;
use App\Http\Middleware\cangetstat;
use App\Http\Middleware\canmanageaccounts;
use App\Http\Middleware\canmanagejobs;
use App\Http\Middleware\EmailVerified;
use App\Http\Middleware\VerifyPincode;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
       $middleware->alias(['verifiedemail'=> EmailVerified::class,
       'isadmin'=> AdminCheck::class,
       'canAddAdmins'=> canaddadmins::class,
       'canGetStat'=> cangetstat::class,
       'canManageAccounts'=> canmanageaccounts::class,
       'canManageJobs'=> canmanagejobs::class,
       'canDeleteAdmin'=> CanDeleteAdmin::class,
       
        //
    ]);})
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();

    