<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobSeeker;
use App\Models\PrivateClient;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator; 

class AdminController extends Controller
{
    public function login(Request $request)
    {
        $validatedData =  Validator::make($request->all(), [
            'username' => 'required',
            'password' => 'required'
        ]);

        if ($validatedData->failed()) {
            response()->json(["success" => false, "message" => $validatedData->errors()], 400);
        }
        $admin = Admin::where('username', $request->username)->first();
        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return response()->json([
                "success" => false,
                "message" => "Invalid Credientials"
            ], 401);
        }

        $token = $admin->createToken("admin_token")->plainTextToken;
        return response()->json([
            "success" => true,
            "username" => $admin->username,
            "token" => $token
        ], 200);
    }
    public function register(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'username' => 'required|unique:admins,username',
            'password' => 'required',
            'adminid' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                "success" => false,
                "message" => $validator->errors()
            ], 400);
        }
        if ($request->adminid != env('ADMIN_ID')) {
            return response()->json([
                "success" => false,
                "message" => "Invalid Credentials"
            ], 401);
        }

        $hashedP = Hash::make($request->password);

        $admin = Admin::create(['username' => $request->username, 'password' => $hashedP]);
        if (!$admin) {
            return response()->json([
                "success" => false,
                "message" => "Something went wrong"
            ], 500);
        }
        $token = $admin->createToken("admin_token")->plainTextToken;

        return response()->json([
            "success" => true,
            "username" => $admin->username,
            "token" => $token
        ], 200);
    }
    public function statistic(Request $request)
    {

        $user = $request->user();

        $admins = Admin::all();
        if (!$admins->contains($user)) {
            return response()->json([
                "error" => "You are not admin"
            ], 401);
        } else {

            $jobs = Job::all();
            $companies = Company::all();
            $privateClients = PrivateClient::all();
            $users  = User::all();
            $jobseekers = JobSeeker::all();



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

            return response()->json(["success" => true, "counts" => [
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
            ]]);
        }
    }

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

        $admins = Admin::all();
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

        $admins = Admin::all();
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

        $admins = Admin::all();
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

        $admins = Admin::all();
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
}
