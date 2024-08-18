<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\CompanyController;
use App\Http\Controllers\EducationController;
use App\Http\Controllers\ExperienceController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\JobSeekerController;
use App\Http\Controllers\PrivateClientController;
use App\Http\Controllers\SkillController;
use App\Http\Controllers\UserController;
use App\Models\JobSeeker;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Laravel\Sanctum\Sanctum;

// user +
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// admin
Route::post('/admin/login', [AdminController::class, 'login']);
Route::post('/admin/register', [AdminController::class, 'register']);
Route::get('/admin/statistic', [AdminController::class, 'statistic'])->middleware("auth:sanctum");
Route::delete('/admin/deletecompany/{companyp}', [AdminController::class, 'deletecompanyA'])->middleware("auth:sanctum");
Route::delete('/admin/deleteprivateclient/{privateclientp}', [AdminController::class, 'deletePrivateClientA'])->middleware("auth:sanctum");
Route::delete('/admin/deleteuser/{userp}', [AdminController::class, 'deleteuserA'])->middleware("auth:sanctum");
Route::delete('/admin/deletejobseeker/{userp}', [AdminController::class, 'dseleteJobSeekerA'])->middleware("auth:sanctum");

//Profiles +
Route::get("profile", [UserController::class, "getuserprofile"])->middleware("auth:sanctum");

// User +
Route::post('register', [UserController::class, "register"]);
Route::post('login', [UserController::class, "login"]);
Route::put('update', [UserController::class, "update"])->middleware("auth:sanctum");
Route::delete('delete', [UserController::class, "delete"])->middleware("auth:sanctum");

//JobSeeker +
Route::post('createjobseeker', [JobSeekerController::class, "createjobseeker"])->middleware("auth:sanctum");
Route::get('showjobseeker', [JobSeekerController::class, "showjobseeker"])->middleware("auth:sanctum");
Route::put('updatejobseeker/{id}', [JobSeekerController::class, "updatejobseeker"])->middleware("auth:sanctum");
Route::delete('deletejobseeker', [JobSeekerController::class, "delete"])->middleware("auth:sanctum");
Route::post('applyjob/{jobid}', [JobSeekerController::class, "applyJob"])->middleware("auth:sanctum");

//PrivateClient +
Route::post('createprivateclient', [PrivateClientController::class, "createprivateclient"])->middleware("auth:sanctum");
Route::post('privatecreatejob', [PrivateClientController::class, "privatecreatejob"])->middleware("auth:sanctum");
Route::put('privatecreateupdate', [PrivateClientController::class, "update"])->middleware("auth:sanctum");
Route::delete('privatecreatedelete', [PrivateClientController::class, "delete"])->middleware("auth:sanctum");

//Company +
Route::post('createcompany', [CompanyController::class, 'createcompany'])->middleware("auth:sanctum");
Route::post('companycreatejob', [CompanyController::class, 'companycreatejob'])->middleware("auth:sanctum");
Route::put('companyupdate', [CompanyController::class, "update"])->middleware("auth:sanctum");
Route::delete('companydelete', [CompanyController::class, "delete"])->middleware("auth:sanctum");




// job +
Route::get('fetchjobs',[JobController::class, 'fetchjobs']);
Route::get('fetchjob/{id}',[JobController::class, 'fetchjob']);
Route::delete('deletejob/{type}/{id}',[JobController::class, 'deletejob'])->middleware("auth:sanctum");
Route::put('editjob/{type}/{id}',[JobController::class, 'editjob'])->middleware("auth:sanctum");



//Education
Route::post('addeducation/{id}', [EducationController::class, 'addeducation'])->middleware("auth:sanctum");;
Route::get('showeducation', [EducationController::class, 'showeducation'])->middleware("auth:sanctum");;
Route::put('updateeducation/{jobseekerid}/{educationid}', [EducationController::class, 'updateeducation'])->middleware("auth:sanctum");
Route::post('deleteeducation/{id}', [EducationController::class, 'deleteeducation'])->middleware("auth:sanctum");

//Experience
Route::post('addexperience/{id}', [ExperienceController::class, 'addexperience'])->middleware("auth:sanctum");;
Route::get('showexperience', [ExperienceController::class, 'showexperience'])->middleware("auth:sanctum");;
Route::put('updateeducation/{jobseekerid}/{educationid}', [EducationController::class, 'updateeducation'])->middleware("auth:sanctum");
Route::post('deleteeducation/{id}', [EducationController::class, 'deleteeducation'])->middleware("auth:sanctum");

//Skill
Route::get("showskill",[SkillController::class,"showskill"])->middleware("auth:sanctum");
Route::post("updateskill/{id}",[SkillController::class,"updateskill"])->middleware("auth:sanctum");