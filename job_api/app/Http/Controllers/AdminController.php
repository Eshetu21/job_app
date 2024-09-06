<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Application;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobSeeker;
use App\Models\PrivateClient;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

use function PHPSTORM_META\map;

class AdminController extends Controller
{
    // company
    // public function cstat($companyid)
    // {
    //     try {
    //         $company = Company::find($companyid);
    //         if (!$company) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "No company exist with this id",
    
    //             ], 401);
    //         }

    //         $jobs = $company->jobs;
    //         if (!$jobs || $jobs->count() == 0) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "Job not found",
    
    //             ], 400);
    //         }

    //         $acceptedCount = 0;
    //         $rejectedCount = 0;
    //         $pendingCount = 0;

    //         $apps = Application::where('company_id', $company->id)->get();
    //         foreach ($apps as $app) {
    //             if ($app->status === 'Accepted') {
    //                 $acceptedCount++;
    //             } elseif ($app->status === 'Rejected') {
    //                 $rejectedCount++;
    //             } else {
    //                 $pendingCount++;
    //             }
    //         }

    //         return response()->json([
    //             'success' => true,
    //             'company' => $company,
    //             'stats' => [
    //                 'total_jobs' => $jobs->count(),
    //                 'jobs'=>$jobs,
    //                 'accepted_count' => $acceptedCount,
    //                 'rejected_count' => $rejectedCount,
    //                 'pending_count' => $pendingCount,
    //             ],
    //         ], 200);
    //     } catch (\Exception $e) {
    //         return response()->json([
    //             'success' => false,
    //             'message' => $e->getMessage(),
    //         ], 400);
    //     }
    // }
    public function deleteCompanyA(Request $request,  $companyId)
    {
        $company = Company::find($companyId);
        if (!$company) {
            return response()->json([
                "success" => false,
                "message" => "No company exist with this id",

            ], 401);
        }

        $userA = $request->user();

        $admins = User::all();
        if (!$admins->contains($userA)) {
            return response()->json([
                "success" => false,
                "message" => "You are not admin",

            ], 401);
        } else {


            try {
                $company->delete();
            } catch (Exception $e) {
                return response()->json([
                    "success" => false,
                    "message" => $e->getMessage(),

                ], 400);
            }
            return response()->json([
                "success" => true,
                "message" => "Company Deleted successfully",

            ], 200);
        }
    }
    // private client
    // public function pcstat($privateclientid)
    // {
    //     try {
    //         $privateclient = Privateclient::findOrFail($privateclientid);


    //         $jobs = $privateclient->jobs;


    //         $acceptedCount = 0;
    //         $rejectedCount = 0;
    //         $pendingCount = 0;


    //         $apps = Application::where('company_id', $privateclient->id)->get();
    //         foreach ($apps as $app) {
    //             if ($app->status === 'Accepted') {
    //                 $acceptedCount++;
    //             } elseif ($app->status === 'Rejected') {
    //                 $rejectedCount++;
    //             } else {
    //                 $pendingCount++;
    //             }
    //         }


    //         return response()->json([
    //             'success' => true,
    //             'privateclient' => $privateclient,
    //             'stats' => [
    //                 'total_jobs' => $jobs->count(),
    //                 'accepted_count' => $acceptedCount,
    //                 'rejected_count' => $rejectedCount,
    //                 'pending_count' => $pendingCount,
    //             ],
    //         ], 200);
    //     } catch (\Exception $e) {
    //         return response()->json([
    //             'success' => false,
    //             'message' => $e->getMessage(),
    //         ], 400);
    //     }
    // }

    public function deletePrivateClientA(Request $request,  $privateclientId)
    {
        $privateclient = PrivateClient::find($privateclientId);
        if (!$privateclient) {
            return response()->json([
                "success" => false,
                "message" => "No private client exist with this id",
            ], 401);
        }
        $userA = $request->user();

        $admins = User::all();
        if (!$admins->contains($userA)) {
            return response()->json([
                "success" => false,
                "message" => "You are not admin",
            ], 401);
        } else {



            try {
                $privateclient->delete();
            } catch (Exception $e) {
                return response()->json([
                    "success" => false,
                    "message" => $e->getMessage(),

                ], 400);
            }
            return response()->json([
                "success" => true,
                "message" => "Private Client Deleted successfully",

            ], 200);
        }
    }
    // job seeker
    public function deleteJobSeekerA(Request $request,  $jobseekerId)
    {
        $jobseeker = JobSeeker::find($jobseekerId);
        if (!$jobseeker) {
            return response()->json([
                "success" => false,
                "message" => "No jobseeker exist with this id",
            ], 401);
        }
        $userA = $request->user();

        $admins = User::all();
        if (!$admins->contains($userA)) {
            return response()->json([
                "success" => false,
                "message" => "You are not admin",
            ], 401);
        } else {

            $jobseeker->delete();

            return response()->json([
                "success" => true,
                "message" => "Jobseeker Deleted successfully",

            ], 200);
        }
    }
    // public function jsstat($id)
    // {
    //     try {

    //         $jobseeker = JobSeeker::findOrFail($id);


    //         $accepted = [];
    //         $rejected = [];
    //         $pending = [];


    //         $applies = Application::where('user_id', $jobseeker->id)->get();


    //         foreach ($applies as $app) {
    //             if ($app->status == "Accepted") {
    //                 $accepted[] = $app;
    //             } elseif ($app->status == "Rejected") {
    //                 $rejected[] = $app;
    //             } else {
    //                 $pending[] = $app;
    //             }
    //         }


    //         return response()->json([
    //             "success" => true,
    //             "data" => [
    //                 "accepted_count" => count($accepted),
    //                 "rejected_count" => count($rejected),
    //                 "pending_count" => count($pending),
    //                 "accepted" => $accepted,
    //                 "rejected" => $rejected,
    //                 "pending" => $pending,
    //             ],
    //         ], 200);
    //     } catch (ValidationException $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->errors(),
    //         ], 400);
    //     } catch (Exception $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->getMessage(),
    //         ], 400);
    //     }
    // }
    // user
    public function getuserprofile($id)
    {
        try {
            $user = User::findorfail($id);
            $profiles = [
                'jobseeker' => $user->jobseeker ? $user->jobseeker->load('user') : null,
                'privateclient' => $user->privateclient ? $user->privateclient->load('user') : null,
                'company' => $user->company ? $user->company->load('user') : null,
            ];

            return response()->json(['profiles' => $profiles], 200);
        } catch (ValidationException $e) {
            return response()->json([
                "success" => false,
                "message" => $e->errors(),


            ], 400);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }
    public function deleteUserA(Request $request,  $userId)
    {
        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                "success" => false,
                "message" => "No user exist with this id",
            ], 401);
        }
        $userA = $request->user();

        $admins = User::all();
        if (!$admins->contains($userA)) {
            return response()->json([
                "success" => false,
                "message" => "You are not admin",
            ], 401);
        } else {

            $user->delete();

            return response()->json([
                "success" => true,
                "message" => "User Deleted successfully",

            ], 200);
        }
    }
    public function statistic(Request $request)
    {

       
            $jobs = Job::all();
            $companies = Company::all();
            $privateClients = PrivateClient::all();
            $users  = User::all();
            $jobseekers = JobSeeker::all();
            $applications = Application::all();
            $admins = $users->where('role','admin');



            $thisweekcompanies = $companies->whereBetween('created_at', [
                Carbon::now()->startOfWeek()->toDateTimeString(),
                Carbon::now()->endOfWeek()->toDateTimeString()
            ]);

            $thismonthcompanies = $companies->whereBetween('created_at', [
                Carbon::now()->startOfMonth()->toDateTimeString(),
                Carbon::now()->endOfMonth()->toDateTimeString()
            ]);


            $thisweekprivateClients = $privateClients->whereBetween('created_at', [
                Carbon::now()->startOfWeek()->toDateTimeString(),
                Carbon::now()->endOfWeek()->toDateTimeString()
            ]);

            $thismonthprivateClients = $privateClients->whereBetween('created_at', [
                Carbon::now()->startOfMonth()->toDateTimeString(),
                Carbon::now()->endOfMonth()->toDateTimeString()
            ]);


            $thisweekjobs = $jobs->whereBetween('created_at', [
                Carbon::now()->startOfWeek()->toDateTimeString(),
                Carbon::now()->endOfWeek()->toDateTimeString()
            ]);

            $thismonthjobs = $jobs->whereBetween('created_at', [
                Carbon::now()->startOfMonth()->toDateTimeString(),
                Carbon::now()->endOfMonth()->toDateTimeString()
            ]);


            $thisweekusers = $users->whereBetween('created_at', [
                Carbon::now()->startOfWeek()->toDateTimeString(),
                Carbon::now()->endOfWeek()->toDateTimeString()
            ]);

            $thismonthusers = $users->whereBetween('created_at', [
                Carbon::now()->startOfMonth()->toDateTimeString(),
                Carbon::now()->endOfMonth()->toDateTimeString()
            ]);
            $thisweekjobseekers = $jobseekers->whereBetween('created_at', [
                Carbon::now()->startOfWeek()->toDateTimeString(),
                Carbon::now()->endOfWeek()->toDateTimeString()
            ]);
            $thismonthjobseekers = $jobseekers->whereBetween('created_at', [
                Carbon::now()->startOfMonth()->toDateTimeString(),
                Carbon::now()->endOfMonth()->toDateTimeString()
            ]);
            $thisweekapplications = $applications->whereBetween('created_at', [
                Carbon::now()->startOfWeek()->toDateTimeString(),
                Carbon::now()->endOfWeek()->toDateTimeString()
            ]);
            $thismonthapplications = $applications->whereBetween('created_at', [
                Carbon::now()->startOfMonth()->toDateTimeString(),
                Carbon::now()->endOfMonth()->toDateTimeString()
            ]);
            $acceptedapps = $applications->where('status','accepted');
            $rejectedapps = $applications->where('status','rejected');
            $pendingapps = $applications->where('status','pending');
           
            return response()->json(["success" => true, "data" => [
                "jobs" => [
                    "thisweek" => [
                        "count" => $thisweekjobs->count(),
                        'jobs' => $thisweekjobs
                    ],
                    "thismonth" => [
                        "count" => $thismonthjobs->count(),
                        'jobs' => $thismonthjobs
                    ],
                    "alltime" => [
                        "count" => $jobs->count(),
                        'jobs' => $jobs
                    ]
                ],
                "users" => [
                    "thisweek" => [
                        "count" => $thisweekusers->count(),
                        'users' => $thisweekusers
                    ],
                    "thismonth" => [
                        "count" => $thismonthusers->count(),
                        'users' => $thismonthusers
                    ],
                    "alltime" => [
                        "count" => $users->count(),
                        'users' => $users
                    ]
                ],

                "companies" => [
                    "thisweek" => [
                        "count" => $thisweekcompanies->count(),
                        'companies' => $thisweekcompanies
                    ],
                    "thismonth" => [
                        "count" => $thismonthcompanies->count(),
                        'companies' => $thismonthcompanies
                    ],
                    "alltime" => [
                        "count" => $companies->count(),
                        'companies' => $companies
                    ]
                ],

                "privateClients" => [
                    "thisweek" => [
                        "count" => $thisweekprivateClients->count(),
                        'privateClients' => $thisweekprivateClients
                    ],
                    "thismonth" => [
                        "count" => $thismonthprivateClients->count(),
                        'privateClients' => $thismonthprivateClients
                    ],
                    "alltime" => [
                        "count" => $privateClients->count(),
                        'privateClients' => $privateClients
                    ]
                ],
                "jobseekers" => [
                    "thisweek" => [
                        "count" => $thisweekjobseekers->count(),
                        'jobseekers' => $thisweekjobseekers
                    ],
                    "thismonth" => [
                        "count" => $thismonthjobseekers->count(),
                        'jobseekers' => $thismonthjobseekers
                    ],
                    "alltime" => [
                        "count" => $jobseekers->count(),
                        'jobseekers' => $jobseekers
                    ]
                ],
                "applications"=>[
                    "thisweek" => [
                        "count" => $thisweekapplications->count(),
                        'applications' => $thisweekapplications,
                       
                    ],
                    "thismonth" => [
                        "count" => $thismonthapplications->count(),
                        'applications' => $thismonthapplications
                    ],
                    "alltime" => [
                        "count" => $thismonthapplications->count(),
                        'applications' => $thismonthapplications
                    ],
                    'accepted'=> [
                        "count"=> $acceptedapps->count(),
                        "acceptedapps"=>$acceptedapps
                    ],
                    'rejected'=> [
                        "count"=> $rejectedapps->count(),
                        "rejectedapps"=>$rejectedapps
                    ],
                    'pending'=> [
                        "count"=> $pendingapps->count(),
                        "pendingapps"=>$pendingapps
                    ]
                    
                    ],
                    "admins"=>[
                        "admins"=> $admins,
                        "count"=>$admins->count()
                    ]
            ]]);
        }
    
    // job and application
    public function deleteJob(Request $request, $jobid)
    {
        try {


            $job = Job::find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }

            $job->delete();
            return response()->json([
                "success" => true,
                "message" => "Job deleted successfuly",

            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                "success" => false,
                "message" => $e->errors(),


            ], 400);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }
    public function jobstat($jobid)
    {
        try {

            $acceptedCount = 0;
            $rejectedCount = 0;
            $pendingCount = 0;
            $job = Job::find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }
            $apps = Application::where('job_id', $jobid)->get();
            foreach ($apps as $app) {
                if ($app->status === 'Accepted') {
                    $acceptedCount++;
                } elseif ($app->status === 'Rejected') {
                    $rejectedCount++;
                } else {
                    $pendingCount++;
                }
            }

            return response()->json([
                'success' => true,
                'job' => $job,
                'stats' => [
                    'apps'=>$apps,
                    'total_apps' => $apps->count(),
                    'accepted_count' => $acceptedCount,
                    'rejected_count' => $rejectedCount,
                    'pending_count' => $pendingCount,
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 400);
        }
    }
    public function deleteappadmin($id)
    {

        try {
            $app = Application::findorfail($id);
            if ($app) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found",
                ], 404);
            }
            File::delete(public_path('uploads/application/cv/' + $app->cv));
            File::delete(public_path('uploads/application/cv/' + $app->cv));
            $app->delete();
            return response()->json([
                "success" => true,
                "message" => "Application deleted",
            ], 204);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
            ], 400);
        }
    }
    public function createadmin(Request $request){
      try {
     
      $validateddata=  $request->validate([
            'email'=>'email|required|string|unique:users,email',
            'password'=>'required|string|min:6',
          
            'add_admins'=> 'required|boolean',
            'manage_jobs'=>'required|boolean',
            'manage_accounts'=>'required|boolean',
            'manage_stats'=>'required|boolean',
            'can_delete_admin'=>'required|boolean'
        ]);
        $admin = User::create([...$validateddata,'firstname'=>'admin','lastname'=>'admin',  'role'=>'admin',]);
        if($admin){
            return response()->json([
                "success" => true,
                "message" => "Admin created successfully",
            ], 200);
        }
      
      }  catch(ValidationException $e){
        return response()->json([
            "success" => false,
            "message" => $e->getMessage(),
        ], 400);
    }catch (Exception $e) {
        return response()->json([
            "success" => false,
            "message" => $e->getMessage(),
        ], 400);
    }
    
    }
    public function deleteadmin($adminid){
        try {
        
          $admin = User::find($adminid);
          if(!$admin){
              return response()->json([
                  "success" => false,
                  "message" => "No admin found",
              ], 200);
          }
        $admin->delete();
      
            return response()->json([
                "success" => true,
                "message" => "Admin deleted successfully",
            ], 200);
        
        }  catch(ValidationException $e){
          return response()->json([
              "success" => false,
              "message" => $e->getMessage(),
          ], 400);
      }catch (Exception $e) {
          return response()->json([
              "success" => false,
              "message" => $e->getMessage(),
          ], 400);
      }
      
      }
    
    // reject and accept jobs
    // public function postjob(Request $request, $jobid)
    // {
    //     try {
           
    //         $job = Job::find($jobid);
    //         if (!$job) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "Job not found",

    //             ], 400);
    //         }

    //         $job->update(["Post"=>true]);
            
    //      //   Mail::to($app->user->email)->send(new AcceptedMail($app->user->name,"Private Client",$app->job->title));
    //         return response()->json([
    //             "success" => true,
    //             "message" => "Job Posted"], 200);
    //     } catch (ValidationException $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->errors(),
    //         ], 400);
    //     } catch (Exception $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->getMessage(),

    //         ], 400);
    //     }
    // }
    // public function ignorejob(Request $request, $jobid)
    // {
    //     try {
           
    //         $job = Job::find($jobid);
    //         if (!$job) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "Job not found",

    //             ], 400);
    //         }

    //         $job->update(["Post"=>false]);
            
    //      //   Mail::to($app->user->email)->send(new AcceptedMail($app->user->name,"Private Client",$app->job->title));
    //         return response()->json([
    //             "success" => true,
    //             "message" => "Job Posted"], 200);
    //     } catch (ValidationException $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->errors(),
    //         ], 400);
    //     } catch (Exception $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->getMessage(),

    //         ], 400);
    //     }
    // }
    
      // -------------------------------------------------------------------------
    // public function login(Request $request)
    // {
    //     $validatedData =  Validator::make($request->all(), [
    //         'username' => 'required',
    //         'password' => 'required'
    //     ]);

    //     if ($validatedData->failed()) {
    //         response()->json(["success" => false, "message" => $validatedData->errors()], 400);
    //     }
    //     $admin = User::where('username', $request->username)->first();
    //     if (!$admin || !Hash::check($request->password, $admin->password)) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => "Invalid Credientials"
    //         ], 401);
    //     }
    //     if(!$admin->role=="admin") {
    //         return response()->json(["success"=>false,"message"=>"you are not admin"],401);
    //     }
    //     $token = $admin->createToken("admin_token")->plainTextToken;
    //     return response()->json([
    //         "success" => true,
    //         "username" => $admin->username,
    //         "token" => $token
    //     ], 200);
    // }
    // public function register(Request $request)
    // {

    //     $validator = Validator::make($request->all(), [
    //         'username' => 'required|unique:admins,username',
    //         'password' => 'required',
    //         'adminid' => 'required'
    //     ]);

    //     if ($validator->fails()) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $validator->errors()
    //         ], 400);
    //     }
    //     if ($request->adminid != env('ADMIN_ID')) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => "Invalid Credentials"
    //         ], 401);
    //     }

    //     $hashedP = Hash::make($request->password);

    //     $admin = User::create(['username' => $request->username, 'password' => $hashedP]);
    //     if (!$admin) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => "Something went wrong"
    //         ], 500);
    //     }
    //     $token = $admin->createToken("admin_token")->plainTextToken;

    //     return response()->json([
    //         "success" => true,
    //         "username" => $admin->username,
    //         "token" => $token
    //     ], 200);
    // }
    // public function getAppById(Request $request, $companyid, $jobid, $appid)
    // {
    //     try {
    //         $company =   Company::find($companyid);
    //         if (!$company) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "company not registerd"
    //             ], 400);
    //         }

    //         $job = $company->jobs->find($jobid);
    //         if (!$job) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "Job not found",

    //             ], 400);
    //         }

    //         $app = $job->applications->find($appid);
    //         if (!$app) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "Application not found",

    //             ], 400);
    //         }

    //         return response()->json([
    //             "success" => true,

    //             "application" => $app->load('job')

    //         ], 200);
    //     } catch (ValidationException $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->errors(),


    //         ], 400);
    //     } catch (Exception $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->getMessage(),

    //         ], 400);
    //     }
    // }
    // public function fetchapps()
    // {

    //     try {
    //         $apps = Application::all();
    //         if ($apps->count() == 0) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "No application found",
    //             ], 404);
    //         }
    //         return response()->json([
    //             "success" => true,
    //             "applications" => $apps,
    //         ], 400);
    //     } catch (Exception $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->getMessage(),
    //         ], 400);
    //     }
    // }
    // public function fetchapp($id)
    // {

    //     try {
    //         $apps = Application::findorfail($id);
    //         if ($apps) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "No application found",
    //             ], 404);
    //         }
    //         return response()->json([
    //             "success" => true,
    //             "application" => $apps,
    //         ], 400);
    //     } catch (Exception $e) {
    //         return response()->json([
    //             "success" => false,
    //             "message" => $e->getMessage(),
    //         ], 400);
    //     }
    // }
    // public function fetchjobs(Request $request)
    // {
    //     try {
    //         $sortBy = $request->input('sortby', 'created_at');
    //         $sortOrder = $request->input('sortorder', 'desc');
    //         $fields = $request->input('fields', '*');
    //         $jobs = Job::select(explode(',', $fields))
    //             ->orderBy($sortBy, $sortOrder)->get();
    //         return response()->json(["success" => true, "jobs" => $jobs], 200);
    //     } catch (Exception $e) {
    //         return response()->json(["success" => false, "message" => $e->getMessage()]);
    //     }
    // }
    // public function fetchjob(Request $request, $id)
    // {
    //     try {


    //         $job = Job::findorfail($id);

    //         return response()->json(["success" => true, "jobs" => $job], 200);
    //     } catch (ModelNotFoundException $m) {
    //         return response()->json(["success" => false, "message" => "Job not found"], 404);
    //     } catch (Exception $e) {
    //         return response()->json(["success" => false, "message" => $e->getMessage()]);
    //     }
    // }
    // public function deletejobadmin(Request $request, $type, $id)
    // {
    //     try {
    //         $job = Job::findOrFail($id);
    //         $user = $request->user();
    //         if ($type == "company") {
    //             $companyId = $user->company?->id;
    //             $jobOwnerId = $job->company_id;
    //             if ($jobOwnerId === $companyId) {
    //                 $job->delete();
    //                 return response()->json(["success" => true, "message" => "Job deleted successfully"], 200);
    //             } else {
    //                 return response()->json(["success" => false, "message" => "You can not delete this job"], 403);
    //             }
    //         } else if ($type == "privateclient") {
    //             $privateClientId = $user->privateclient?->id;
    //             $jobOwnerId = $job->private_client_id;
    //             if ($jobOwnerId === $privateClientId) {
    //                 $job->delete();
    //                 return response()->json(["success" => true, "message" => "Job deleted successfully"], 200);
    //             } else {
    //                 return response()->json(["success" => false, "message" => "You can not delete this job"], 403);
    //             }
    //         } else {
    //             return response()->json(["success" => false, "message" => "Page not found"], 400);
    //         }
    //     } catch (ModelNotFoundException $m) {
    //         return response()->json(["success" => false, "message" => "Job not found"], 404);
    //     }
    // }
    //    public function getAllApp($jobid)
    //     {
    //         try {


    //             $job = Job::find($jobid);
    //             if (!$job) {
    //                 return response()->json([
    //                     "success" => false,
    //                     "message" => "Job not found",

    //                 ], 400);
    //             }

    //             $apps = $job->applications;
    //             if (!$apps || $apps->count() == 0) {
    //                 return response()->json([
    //                     "success" => false,
    //                     "message" => "Application not found",

    //                 ], 400);
    //             }
    //             return response()->json([
    //                 "success" => true,

    //                 "applications" => $apps->load(['job', 'jobseeker'])

    //             ], 200);
    //         } catch (ValidationException $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->errors(),


    //             ], 400);
    //         } catch (Exception $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->getMessage(),

    //             ], 400);
    //         }
    //     }
    //     public function getPCJobs($privateclientId)
    //     {
    //         $privateclient =   PrivateClient::find($privateclientId);
    //         if (!$privateclient) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "privateclient not registerd"
    //             ], 400);
    //         }
    //         try {
    //             $jobs = $privateclient->jobs;
    //             if (!$jobs || $jobs->count() == 0) {
    //                 return response()->json([
    //                     "success" => false,
    //                     "message" => "Job not found",

    //                 ], 400);
    //             }
    //             return response()->json([
    //                 "success" => true,
    //                 "jobs" => $jobs,

    //             ], 200);
    //         } catch (ValidationException $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->errors(),


    //             ], 400);
    //         } catch (Exception $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->getMessage(),

    //             ], 400);
    //         }
    //     }
    //    public function getCJobs(Request $request, $companyid)
    //     {
    //         $company =   Company::find($companyid);
    //         if (!$company) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => "company not registerd"
    //             ], 400);
    //         }
    //         try {
    //             $jobs = $company->jobs;
    //             if (!$jobs || $jobs->count() == 0) {
    //                 return response()->json([
    //                     "success" => false,
    //                     "message" => "Job not found",

    //                 ], 400);
    //             }
    //             return response()->json([
    //                 "success" => true,
    //                 "jobs" => $jobs,

    //             ], 200);
    //         } catch (ValidationException $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->errors(),


    //             ], 400);
    //         } catch (Exception $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->getMessage(),

    //             ], 400);
    //         }
    //     }
    //   public function deleteApp(Request $request, $appid)
    //     {
    //         try {


    //             $app = Application::find($appid);
    //             if (!$app) {
    //                 return response()->json([
    //                     "success" => false,
    //                     "message" => "Application not found",

    //                 ], 400);
    //             }

    //             $app->delete();
    //             return response()->json([
    //                 "success" => true,
    //                 "message" => "Application deleted successfuly",

    //             ], 200);
    //         } catch (ValidationException $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->errors(),


    //             ], 400);
    //         } catch (Exception $e) {
    //             return response()->json([
    //                 "success" => false,
    //                 "message" => $e->getMessage(),

    //             ], 400);
    //         }
    //     }
}
