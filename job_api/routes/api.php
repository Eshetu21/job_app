<?php

use App\Http\Controllers\CompanyController;
use App\Http\Controllers\EducationController;
use App\Http\Controllers\JobSeekerController;
use App\Http\Controllers\PrivateClientController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

//Profiles
Route::get("profile", [UserController::class, "getuserprofile"])->middleware("auth:sanctum");

// User
Route::post('register', [UserController::class, "register"]);
Route::post('login', [UserController::class, "login"]);
Route::put('update', [UserController::class, "update"])->middleware("auth:sanctum");
Route::delete('delete', [UserController::class, "delete"])->middleware("auth:sanctum");

//JobSeeker
Route::post('createjobseeker', [JobSeekerController::class, "createjobseeker"])->middleware("auth:sanctum");
Route::get('showjobseeker', [JobSeekerController::class, "showjobseeker"])->middleware("auth:sanctum");
Route::put('updatejobseeker/{id}', [JobSeekerController::class, "updatejobseeker"])->middleware("auth:sanctum");
Route::delete('deletejobseeker/{id}', [JobSeekerController::class, "deletejobseeker"])->middleware("auth:sanctum");

//PrivateClient
Route::post('createprivateclient', [PrivateClientController::class, "createprivateclient"])->middleware("auth:sanctum");
Route::post('privatecreatejob', [PrivateClientController::class, "privatecreatejob"])->middleware("auth:sanctum");

//Company
Route::post('createcompany', [CompanyController::class, 'createcompany'])->middleware("auth:sanctum");
Route::post('companycreatejob', [CompanyController::class, 'companycreatejob'])->middleware("auth:sanctum");

//Education
Route::post('addeducation', [EducationController::class, 'addeducation'])->middleware("auth:sanctum");;
Route::post('showeducation/{id}', [EducationController::class, 'showeducation'])->middleware("auth:sanctum");;
Route::post('updateeducation/{id}', [EducationController::class, 'updateeducation'])->middleware("auth:sanctum");
Route::post('deleteeducation/{id}', [EducationController::class, 'deleteeducation'])->middleware("auth:sanctum");
