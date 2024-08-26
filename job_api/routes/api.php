<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\CompanyController;
use App\Http\Controllers\EducationController;
use App\Http\Controllers\ExperienceController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\JobSeekerController;
use App\Http\Controllers\LanguageController;
use App\Http\Controllers\PrivateClientController;
use App\Http\Controllers\SkillController;
use App\Http\Controllers\UserController;
use App\Models\JobSeeker;
use App\Models\Language;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Request as FacadesRequest;
use Illuminate\Support\Facades\Route;
use Laravel\Sanctum\Sanctum;


Route::post('register', [UserController::class, "register"]);
Route::post('login', [UserController::class, "login"]);



Route::middleware("auth:sanctum")->group(function () {
    // user
    Route::post('sendpincode', [UserController::class, "sendpin"])->middleware('throttle:1,20');
    Route::post('checkpincode', [UserController::class, "checkpincode"]);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    //admin
    Route::post('/admin/login', [AdminController::class, 'login']);
    Route::post('/admin/register', [AdminController::class, 'register']);
    Route::get('/admin/statistic', [AdminController::class, 'statistic']);
    Route::delete('/admin/deletecompany/{companyp}', [AdminController::class, 'deletecompanyA']);
    Route::delete('/admin/deleteprivateclient/{privateclientp}', [AdminController::class, 'deletePrivateClientA']);
    Route::delete('/admin/deleteuser/{userp}', [AdminController::class, 'deleteuserA']);
    Route::delete('/admin/deletejobseeker/{userp}', [AdminController::class, 'dseleteJobSeekerA']);
});

//PrivateClient +
Route::post('createprivateclient', [PrivateClientController::class, "createprivateclient"])->middleware("auth:sanctum");
Route::get('showprivateclient', [PrivateClientController::class, "showprivateclient"])->middleware("auth:sanctum");
Route::post('privatecreatejob', [PrivateClientController::class, "privatecreatejob"])->middleware("auth:sanctum");
Route::put('privatecreateupdate', [PrivateClientController::class, "update"])->middleware("auth:sanctum");
Route::delete('privatecreatedelete', [PrivateClientController::class, "delete"])->middleware("auth:sanctum");

Route::middleware("auth:sanctum", 'verifiedemail')->group(
    function () {
        // user
        Route::put('update', [UserController::class, "update"]);
        Route::delete('delete', [UserController::class, "delete"]);
        Route::get("profile", [UserController::class, "getuserprofile"]);


        // jobseeker
        Route::post('createjobseeker', [JobSeekerController::class, "createjobseeker"]);
        Route::get('showjobseeker', [JobSeekerController::class, "showjobseeker"]);
        Route::put('updatejobseeker', [JobSeekerController::class, "updatejobseeker"]);
        Route::put('updatecv', [JobSeekerController::class, "updatecv"]);
        Route::delete('deletejobseeker', [JobSeekerController::class, "delete"]);
        Route::post('applyjob/{jobid}', [JobSeekerController::class, "applyJob"]);
        Route::get('getapplications', [JobSeekerController::class, "getapplications"]);
        Route::delete('deleteapplications/{appid}', [JobSeekerController::class, "deleteApplication"]);


        // Route::post('updateapplication/{appid}', [JobSeekerController::class, "updateApplication"]);

        //PrivateClient +
        Route::post('createprivateclient', [PrivateClientController::class, "createprivateclient"]);
        Route::post('privatecreatejob', [PrivateClientController::class, "privatecreatejob"]);
        Route::put('privatecreateupdate', [PrivateClientController::class, "update"]);
        Route::delete('privatecreatedelete', [PrivateClientController::class, "delete"]);

        //Company +
        Route::post('createcompany', [CompanyController::class, 'createcompany']);
        Route::post('companycreatejob', [CompanyController::class, 'companycreatejob']);
        Route::put('companyupdate', [CompanyController::class, "update"]);
        Route::delete('companydelete', [CompanyController::class, "delete"]);
        Route::get('getmyjobs', [CompanyController::class, "getMyJobs"]);
        Route::get('getmyjobbyid/{jobid}', [CompanyController::class, "getJobbyId"]);
        Route::delete('deletejob/{jobid}', [CompanyController::class, "deleteJob"]);
        Route::put('updatejob/{jobid}', [CompanyController::class, "updateJob"]);
        Route::put('rejectapp/{jobid}/{appid}', [CompanyController::class, "rejectApplication"]);
        Route::put('acceptapp/{jobid}/{appid}', [CompanyController::class, "acceptApplication"]);
        Route::get('getappbyid/{jobid}/{appid}', [CompanyController::class, "getAppById"]);
        Route::get('getallapp/{jobid}', [CompanyController::class, "getAllApp"]);




        // job +


        //Education
        Route::post('addeducation/{id}', [EducationController::class, 'addeducation']);;
        Route::get('showeducation', [EducationController::class, 'showeducation']);;
        Route::put('updateeducation/{jobseekerid}/{educationid}', [EducationController::class, 'updateeducation']);
        Route::post('deleteeducation/{id}', [EducationController::class, 'deleteeducation']);

        //Experience
        Route::post('addexperience/{id}', [ExperienceController::class, 'addexperience']);;
        Route::get('showexperience', [ExperienceController::class, 'showexperience']);;
        Route::put('updateexperience/{jobseekerid}/{experienceid}', [ExperienceController::class, 'updateexperience']);
        Route::post('deleteexperience/{id}', [ExperienceController::class, 'deleteexperience']);

        //Skill
        Route::get("showskill", [SkillController::class, "showskill"]);
        Route::post("updateskill/{id}", [SkillController::class, "updateskill"]);

        //Language
        Route::get("showlanguage", [LanguageController::class, "showlanguage"]);
        Route::post("updatelanguage/{id}", [LanguageController::class, "updatelanguage"]);

        Route::delete('deletejob/{type}/{id}', [JobController::class, 'deletejob']);
        Route::put('editjob/{type}/{id}', [JobController::class, 'editjob']);
    }
);
Route::get('fetchjobs', [JobController::class, 'fetchjobs']);
Route::get('fetchjob/{id}', [JobController::class, 'fetchjob']);
