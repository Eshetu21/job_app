<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\ApplicationController;
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
// auth
Route::post('register', [UserController::class, "register"]);
Route::post('login', [UserController::class, "login"]);
// eshetu
Route::post('createjobseeker', [JobSeekerController::class, "createjobseeker"]);
Route::get('showjobseeker', [JobSeekerController::class, "showjobseeker"]);
Route::put('updatejobseeker', [JobSeekerController::class, "updatejobseeker"]);
Route::put('updatecv', [JobSeekerController::class, "updatecv"]);
Route::delete('deletejobseeker', [JobSeekerController::class, "delete"]);
Route::post('applyjob/{jobid}', [JobSeekerController::class, "applyJob"]);
Route::get('getapplications', [JobSeekerController::class, "getapplications"]);
Route::delete('deleteapplications/{appid}', [JobSeekerController::class, "deleteApplication"]);
Route::post('createprivateclient', [PrivateClientController::class, "createprivateclient"]);
Route::post('privatecreatejob', [PrivateClientController::class, "privatecreatejob"]);
Route::put('privatecreateupdate', [PrivateClientController::class, "update"]);
Route::delete('privatecreatedelete', [PrivateClientController::class, "delete"]);

// table for categories and and cities
// notify jobseekers 
// admin control


Route::middleware("auth:sanctum")->group(
    
    function () {
        // auth
        Route::post('logout', [UserController::class, "logout"]);
        // user
        Route::get("profile", [UserController::class, "getuserprofile"]);
        Route::post('checkpincode', [UserController::class, "checkpincode"]);
        Route::get('user', function (Request $request) {
            return response()->json(["success" => true, "user" => $request->user()]);
        });
        Route::put('update', [UserController::class, "update"]);
        Route::delete('delete', [UserController::class, "delete"]);
        Route::post('sendpincode', [UserController::class, "sendpin"])->middleware('throttle:1,20');
        Route::post('changepassword', [UserController::class, "changepassword"]);

        // admin 
        // --------------------------------------------------------------------------------------------------------
        Route::prefix('admin')->middleware('isadmin')->group(function () {

            // company

            Route::delete('c/delete/{companyId}', [AdminController::class, 'deletecompanyA'])->middleware('canManageAccounts');

            // private client 

            Route::delete('pc/deletepc/{privateclientId}', [AdminController::class, 'deletePrivateClientA'])->middleware('canManageAccounts');

            // jobseeker
            Route::delete('deletejs/{jobseekerId}', [AdminController::class, 'deleteJobSeekerA'])->middleware('canManageAccounts');

            // user
            Route::get("u/profile/{id}", [AdminController::class, "getuserprofile"])->middleware('canManageAccounts');
            Route::delete('u/deleteu/{userId}', [AdminController::class, 'deleteuserA'])->middleware('canManageAccounts');

            // job and app 
            Route::prefix('job')->middleware('verifiedemail')->group(function () {


                Route::delete('delete/{jobid}', [AdminController::class, "deleteJob"])->middleware('canManageJobs');
                Route::get('getstat/{jobid}', [AdminController::class, "jobstat"])->middleware('canGetStat');
                Route::put('postjob/{jobid}', [AdminController::class, "postjob"])->middleware('canManageJobs');
                Route::put('ignorejob/{jobid}', [AdminController::class, "ignorejob"])->middleware('canManageJobs');
            });
            Route::prefix('app')->group(function () {


                Route::delete('delete/{appid}', [AdminController::class, "deleteAppadmin"])->middleware('canManageJobs');;
            });


            Route::get('statistic', [AdminController::class, 'statistic'])->middleware('canGetStat');;
            Route::post('createadmin', [AdminController::class, 'createadmin'])->middleware('canAddAdmins');;
            Route::delete('deleteadmin', [AdminController::class, 'deleteadmin'])->middleware('canDeleteAdmin');;
        });
        Route::middleware('auth:sanctum')->group(function () {
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
            });        //private client 
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
            });        //Company
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
        });
        // --------------------------------------------------------------------------------------------------------

    }
); // public
// --------------------------------------------------------------------------------------------------------
Route::prefix('p')->group(function () {
    Route::prefix('job')->group(function () {
        Route::get('get', [PublicController::class, 'fetchjobs']);
        Route::get('get/{id}', [PublicController::class, 'fetchjob']);
    });
    Route::get('u/{user_id}', [PublicController::class, "getuser"]);
    Route::post('u/forget_password', [PublicController::class, "forgetpassword"])->middleware('throttle:1,20');;
    Route::post('u/reset_password', [PublicController::class, "resetpassword"]);
    Route::get('c/{company_id}', [PublicController::class, "getcompany"]);
    Route::get('c/get/{$companyid}', [PublicController::class, "getCJobs"]);
    Route::get('pc/{privateclient_id}', [PublicController::class, "getprivateclient"]);
    Route::get('pc/get/{privateclientId}', [PublicController::class, "getPCJobs"]);
    Route::get('js/{jobseeker_id}', [PublicController::class, "getjobseeker"]);
});
    // --------------------------------------------------------------------------------------------------------
