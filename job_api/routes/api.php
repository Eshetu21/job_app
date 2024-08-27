<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\CompanyController;
use App\Http\Controllers\EducationController;
use App\Http\Controllers\ExperienceController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\JobSeekerController;
use App\Http\Controllers\LanguageController;
use App\Http\Controllers\PrivateClientController;
use App\Http\Controllers\PublicController;
use App\Http\Controllers\SkillController;
use App\Http\Controllers\UserController;
use App\Models\JobSeeker;
use App\Models\Language;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Request as FacadesRequest;
use Illuminate\Support\Facades\Route;
use Laravel\Sanctum\Sanctum;


// admin


// User 
// all routes works fine
Route::post('register', [UserController::class, "register"]);
Route::post('login', [UserController::class, "login"]);
Route::middleware("auth:sanctum")->group(function () {
    Route::post('logout', [UserController::class, "logout"]);
    Route::get("profile", [UserController::class, "getuserprofile"]);
    Route::post('checkpincode', [UserController::class, "checkpincode"]);
    Route::get('user', function (Request $request) {
        return response()->json(["success"=>true,"user"=>$request->user()]);
    });
    Route::put('update', [UserController::class, "update"]);
    Route::delete('delete', [UserController::class, "delete"]);
    Route::post('sendpincode', [UserController::class, "sendpin"])->middleware('throttle:1,20');
    Route::post('changepassword', [UserController::class, "changepassword"]);


    // admin 
    Route::prefix('admin')->group(function () {


        Route::post('login', [AdminController::class, 'login']);
        Route::post('register', [AdminController::class, 'register']);
        Route::get('statistic', [AdminController::class, 'statistic']);
        Route::delete('deletec/{companyId}', [AdminController::class, 'deletecompanyA']);
        Route::delete('deletepc/{privateclientId}', [AdminController::class, 'deletePrivateClientA']);
        Route::delete('deleteu/{userId}', [AdminController::class, 'deleteuserA']);
        Route::delete('deletejs/{jobseekerId}', [AdminController::class, 'deleteJobSeekerA']);
    });
});

Route::middleware("auth:sanctum", "verifiedemail")->group(
    function () {




        // jobseeker
        Route::prefix('js')->group(function () {
            Route::post('create', [JobSeekerController::class, "createjobseeker"]);
            Route::get('get', [JobSeekerController::class, "showjobseeker"]);
            Route::put('update', [JobSeekerController::class, "updatejobseeker"]);
             Route::delete('delete', [JobSeekerController::class, "delete"]);
            Route::prefix('app')->group(function () { 
                Route::post('apply/{jobid}', [JobSeekerController::class, "applyJob"]);
                Route::get('get', [JobSeekerController::class, "getapplications"]);
                Route::get('get/{appid}', [JobSeekerController::class, "getapplication"]);
                Route::delete('delete/{appid}', [JobSeekerController::class, "deleteApplication"]);
            });
             });


        //private client 
        Route::prefix('pc')->group(function () {
            Route::post('create', [PrivateClientController::class, "createprivateclient"])->middleware("auth:sanctum");
            Route::get('get', [PrivateClientController::class, "showprivateclient"])->middleware("auth:sanctum");
            Route::put('update', [PrivateClientController::class, "update"])->middleware("auth:sanctum");
            Route::delete('delete', [PrivateClientController::class, "delete"])->middleware("auth:sanctum");
            Route::prefix('job')->group(function () {
                Route::get('get', [PrivateClientController::class, "getMyJobs"]);
                Route::get('get/{jobid}', [PrivateClientController::class, "getJobbyId"]);
                Route::post('create', [PrivateClientController::class, 'privateclientcreatejob']);
                Route::delete('delete/{jobid}', [PrivateClientController::class, "deleteJob"]);
                Route::put('update/{jobid}', [PrivateClientController::class, "updateJob"]);
            });
            Route::prefix('app')->group(function () {
                Route::put('reject/{jobid}/{appid}', [PrivateClientController::class, "rejectApplication"]);
                Route::put('accept/{jobid}/{appid}', [PrivateClientController::class, "acceptApplication"]);
                Route::get('get/{jobid}/{appid}', [PrivateClientController::class, "getAppById"]);
                Route::get('get/{jobid}', [PrivateClientController::class, "getAllApp"]);
            });
        });



        //Company
        Route::prefix('c')->group(function () {
            Route::post('create', [CompanyController::class, 'createcompany']);
            Route::get('get', [CompanyController::class, "showcompany"])->middleware("auth:sanctum");
            Route::put('update', [CompanyController::class, "update"]);
            Route::delete('delete', [CompanyController::class, "delete"]);
            Route::prefix('job')->group(function () {
                Route::get('get', [CompanyController::class, "getMyJobs"]);
                Route::get('get/{jobid}', [CompanyController::class, "getJobbyId"]);
                Route::post('create', [CompanyController::class, 'companycreatejob']);
                Route::delete('delete/{jobid}', [CompanyController::class, "deleteJob"]);
                Route::put('update/{jobid}', [CompanyController::class, "updateJob"]);
            });

            Route::prefix('app')->group(function () {
                Route::put('reject/{jobid}/{appid}', [CompanyController::class, "rejectApplication"]);
                Route::put('accept/{jobid}/{appid}', [CompanyController::class, "acceptApplication"]);
                Route::get('get/{jobid}/{appid}', [CompanyController::class, "getAppById"]);
                Route::get('get/{jobid}', [CompanyController::class, "getAllApp"]);
            });
        });

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
    }
);


// public

Route::prefix('p')->group(function (){
    Route::prefix('job')->group(function () {
        Route::get('get', [JobController::class, 'fetchjobs']);
        Route::get('get/{id}', [JobController::class, 'fetchjob']);
        
    
    });

Route::get('pc/{privateclient_id}', [PublicController::class, "getprivateclient"]);
Route::get('c/{company_id}', [PublicController::class, "getcompany"]);
Route::get('js/{jobseeker_id}', [PublicController::class, "getjobseeker"]);
Route::get('u/{user_id}', [PublicController::class, "getuser"]);

});