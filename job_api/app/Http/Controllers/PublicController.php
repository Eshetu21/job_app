<?php

namespace App\Http\Controllers;

use App\Mail\ForgetPasswordReset;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobSeeker;
use App\Models\Privateclient;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;

class PublicController extends Controller
{
    public function forgetpassword(Request $request)
    {

        $request->validate([
            'email' => 'required|email'
        ]);

        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json([
                "success" => false,
                "message" => "User doesn't exists"
            ], 400);
        }
        try {

            $pin = rand(100000, 999999);
            $pincode_expire = Carbon::now()->addMinutes(5)->timestamp;

            $user->update(['pincode' => $pin, "pincode_expire" => $pincode_expire]);
            $user->save();

            $username =  $user->firstname . " " .  $user->lastname;

            Mail::to($user->email)->send(new ForgetPasswordReset($pin, $username));
            return response()->json(["success" => true, "messasge" => "Pincode send"]);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500);
        }
    }

    public function setpassword(Request $request)
    {
        try {
            $user = User::where('email', $request->email)->first();
            if (!$user) {
                return response()->json([
                    "success" => false,
                    "message" => "User doesn't exists"
                ], 400);
            }
            $request->validate(["newpassword" => 'required|string|min:6']);
            if (!$user->resetpin_verified) {
                return response()->json(["success" => false, "message" => "First verify Otp"], 401);
            }
            $user->update(['password' => Hash::make($request->newpassword)]);
            $user->update(["resetpin_verified" => false]);
            $user->save();

            return response()->json([
                "success" => true,
                "message" => "Password Updated",

            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500);
        }
    }

    public function resetpassword(Request $request)
    {




        $request->validate([


            'pincode' => 'required|integer',
            'email' => 'required'
        ]);
        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json([
                "success" => false,
                "message" => "User doesn't exists"
            ], 400);
        }

        $pin = $request->pincode;

        if ($user->pincode == null) {
            return response()->json([
                "success" => false,
                "message" => "Not requested",

            ], 400);
        }

        if ($user->pincode_expire < Carbon::now()->timestamp) {
            return response()->json([
                "success" => false,
                "message" => "Pincode Expired",

            ], 400);
        }
        if ((int)$pin === (int)$user->pincode) {

            $user->update(["pincode" => null, "pincode_expire" => Carbon::now()->format('Uu') - 1000, "resetpin_verified" => true]);


            $user->save();
            return response()->json([
                "success" => true,
                "message" => "Otp Verified",

            ], 200);
        }

        return response()->json([
            "success" => false,
            "message" => "Invalid Pincode",

        ], 400);
    }
    public function getPrivateclient($privateclient_id)
    {


        $privateclient = Privateclient::findorfail($privateclient_id);
        if (!$privateclient) {
            return response()->json([
                "success" => false,
                "message" => "privateclient doesn't exists"
            ], 400);
        }
        return response()->json([
            "success" => true,
            "privateclient" => $privateclient
        ], 200);
    }



    public function getCompany($company_id)
    {


        $company = Company::findorfail($company_id);
        if (!$company) {
            return response()->json([
                "success" => false,
                "message" => "company doesn't exists"
            ], 400);
        }
        return response()->json([
            "success" => true,
            "company" => $company
        ], 200);
    }

    public function getJobseeker($jobseeker_id)
    {


        $jobseeker = JobSeeker::findorfail($jobseeker_id);
        if (!$jobseeker) {
            return response()->json([
                "success" => false,
                "message" => "jobseeker doesn't exists"
            ], 400);
        }
        return response()->json([
            "success" => true,
            "jobseeker" => $jobseeker
        ], 200);
    }
    public function getUser($user_id)
    {


        $user = User::findorfail($user_id);
        if (!$user) {
            return response()->json([
                "success" => false,
                "message" => "user doesn't exists"
            ], 400);
        }
        return response()->json([
            "success" => true,
            "user" => $user
        ], 200);
    }
    public function fetchjobs(Request $request)
    {
        try {
            $sortBy = $request->input('sortby', 'created_at');
            $sortOrder = $request->input('sortorder', 'desc');
            $fields = $request->input('fields', '*');
            $jobs = Job::select(explode(',', $fields))
                ->orderBy($sortBy, $sortOrder)->get();
            return response()->json(["success" => true, "jobs" => $jobs], 200);
        } catch (Exception $e) {
            return response()->json(["success" => false, "message" => $e->getMessage()]);
        }
    }
    public function fetchjob(Request $request, $id)
    {
        try {


            $job = Job::findorfail($id);

            return response()->json(["success" => true, "jobs" => $job], 200);
        } catch (ModelNotFoundException $m) {
            return response()->json(["success" => false, "message" => "Job not found"], 404);
        } catch (Exception $e) {
            return response()->json(["success" => false, "message" => $e->getMessage()]);
        }
    }
    public function getPCJobs($privateclientId)
    {
        $privateclient =   PrivateClient::find($privateclientId);
        if (!$privateclient) {
            return response()->json([
                "success" => false,
                "message" => "privateclient not registerd"
            ], 400);
        }
        try {
            $jobs = $privateclient->jobs;
            if (!$jobs || $jobs->count() == 0) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }
            return response()->json([
                "success" => true,
                "jobs" => $jobs,

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
    public function getCJobs(Request $request, $companyid)
    {
        $company =   Company::find($companyid);
        if (!$company) {
            return response()->json([
                "success" => false,
                "message" => "company not registerd"
            ], 400);
        }
        try {
            $jobs = $company->jobs;
            if (!$jobs || $jobs->count() == 0) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }
            return response()->json([
                "success" => true,
                "jobs" => $jobs,

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
}
