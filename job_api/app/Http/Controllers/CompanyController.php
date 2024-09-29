<?php

namespace App\Http\Controllers;

use App\Mail\AcceptedMail;
use App\Mail\RejectedMail;
use App\Models\Application;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobSeeker;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class CompanyController extends Controller
{

    public function createcompany(Request $request)
    {

        try {
            $user = $request->user();
            if ($user->Company) {
                return response()->json([
                    "success" => false,
                    "message" => "Company already exists"
                ], 400);
            }
            $validatedData = $request->validate([
                "company_name" => "required|string|unique:companies",
                'company_logo' => 'required|mimes:png,jpg,jpeg|max:2048',
                "company_phone" => "required|string",
                "company_address" => "required|string",
                "company_description" => "required|string"
            ]);

            if ($request->has('company_logo')) {
                $company_logo = $request->file('company_logo');

                $originalfilename = $company_logo->getClientOriginalName();
                $filename = time()."-".$user->id."-".$originalfilename;
                $company_logo->move(public_path('uploads/company_logo'), $filename);
                $validatedData["user_id"] = $user->id;
                $validatedData["company_logo"] = 'uploads/company_logo/' . $filename;
                $company = Company::create($validatedData);
            }
            return response()->json([
                "success" => true,
                'message' => 'Company profile created successfully.',
                'company' => $company
            ], 201);
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
    public function showcompany(Request $request)
    {
        $user = $request->user();
        $company = Company::with('user')->where("user_id", $user->id)->first();
        if (!$user->company) {
            return response()->json([
                "success" => false,
                "message" => "company doesn't exists"
            ], 400);
        }
        return response()->json([
            "success" => true,
            "company" => [
                "company_name" => $company->company_name,
                "company_logo" => url($company->company_logo),
                "company_phone" => $company->company_phone,
                "company_address" => $company->company_address,
                "company_description" => $company->company_description,
            ]
        ], 200);
    }
    public function update(Request $request)
    {
        try {
            $user = $request->user();

            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "Company not registered",
                ], 400);
            }
            $validatedData = Validator::make($request->all(), [
                "company_name" => "nullable|string|unique:companies,company_name," . $user->company->id,
                "company_logo" => "nullable|mimes:png,jpg,jpeg|max:2048",
                "company_phone" => "nullable|string",
                "company_address" => "nullable|string",
                "company_description" => "nullable|string",
            ]);

            if ($validatedData->fails()) {
                return response()->json([
                    "success" => false,
                    "message" => $validatedData->errors(),
                ], 400);
            }

            $company = $user->company;

            if ($request->hasFile('company_logo')) {

                $companyLogoPath = $company->company_logo;

                if (File::exists($companyLogoPath)) {
                    File::delete($companyLogoPath);
                }
                $companyLogo = $request->file('company_logo');
                $filename = time()."-".$user->id."-".$companyLogo->getClientOriginalName();
                $companyLogo->move(public_path('uploads/company_logo'), $filename);
                $company->update(['company_logo' => 'uploads/company_logo/' . $filename]);
            }
            $company->update([
                "company_name" => $validatedData->getData()["company_name"] ?? $company->company_name,
                "company_phone" => $validatedData->getData()["company_phone"] ?? $company->company_phone,
                "company_address" => $validatedData->getData()["company_address"] ?? $company->company_address,
                "company_description" => $validatedData->getData()["company_description"] ?? $company->company_description,
            ]);

            return response()->json([
                "success" => true,
                "message" => "Data updated successfully",
                "updatedCompany" => $company,
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

    public function delete(Request $request)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $company = $user->company;
            $companyPath = public_path('uploads/company_logo/' . $company->company_logo);

            if (File::exists($companyPath)) {
                File::delete($companyPath);
            }
            $user->company->delete();
            return response()->json([
                "success" => true,
                "message" => "Company Deleted successfully",

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
    public function companyCreateJob(Request $request)
    {
        try {
            $user = $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }
            $validatedData = $request->validate([

                'title' => 'required|string',
                'type' => 'required|string',
                'sector' => 'required|string',
                'city' => 'required|string',
                'gender' => 'required|string',
                'salary' => 'nullable|numeric',
                'deadline' => 'required|string',
                'description' => 'required|string',

            ]);
            $validatedData['company_id'] = $user->company->id;
            $job = $user->company->jobs()->create(
                $validatedData
            );

            $user->company->load('user');
            return response()->json([
                "success" => true,
                "message" => "job created sucessfully",
                "job" => $job,

            ], 201);
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

    public function getMyJobs(Request $request)
    {
        $user =   $request->user();
        if (!$user->company) {
            return response()->json([
                "success" => false,
                "message" => "company not registerd"
            ], 400);
        }
        try {
            $jobs = $user->company->jobs;
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
    public function deleteJob(Request $request, $jobid)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $user->company->jobs->find($jobid);
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
    public function updateJob(Request $request, $jobid)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $user->company->jobs->find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }

            $validatedData = $request->validate([

                'title' => 'required|string',
                'type' => 'required|string',
                'sector' => 'required|string',
                'city' => 'required|string',
                'gender' => 'required|string',
                'salary' => 'nullable|numeric',
                'deadline' => 'required|string',
                'description' => 'required|string',
            ]);

            $job->update([
                'title' =>  $validatedData['title'] ??  $job->title,
                'type' =>  $validatedData["type"] ??  $job->type,
                'sector' =>  $validatedData["sector"] ??  $job->sector,
                'city' =>  $validatedData["city"] ??  $job->city,
                'gender' =>  $validatedData["gender"] ??  $job->gender,
                'salary' => $validatedData["salary"] ??  $job->salary,
                'deadline' => $validatedData["deadline"] ??  $job->deadline,
                'description' => $validatedData["description"] ??  $job->description,
            ]);
            return response()->json([
                "success" => true,
                "message" => "Job Updated successfuly",
                "updatedjob" => $job

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
    public function getJobbyId(Request $request, $companyid, $jobid)
    {
        try {
            $company =   Company::find($companyid);
            if (!$company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $company->jobs->find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }
            return response()->json([
                "success" => true,
                "job" => $job

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
    public function rejectApplication(Request $request, $jobid, $appid)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $user->company->jobs->find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }

            $app = $job->applications->find($appid);
            if (!$app) {
                return response()->json([
                    "success" => false,
                    "message" => "Application not found",

                ], 400);
            }
            if ($app->status == "Rejected") {
                return response()->json([
                    "success" => false,
                    "message" => "Already Rejected",

                ], 400);
            }
            $validatedData = $request->validate([
                'statement' => 'string',

            ]);

            $app->update([
                'statement' => isset($validatedData["statement"]) ? $validatedData["statement"] : null,
                'status' => "Rejected"
            ]);
            Mail::to($app->jobseeker->email)->send(new RejectedMail($app->jobseeker->firstname, $app->job->company->company_name, $app->job->title));

            return response()->json([
                "success" => true,
                "message" => "Application Rejected",
                "application" => $app

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
    public function acceptApplication(Request $request, $jobid, $appid)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $user->company->jobs->find($jobid);

            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }

            $app = $job->applications->find($appid);

            if (!$app) {
                return response()->json([
                    "success" => false,
                    "message" => "Application not found",

                ], 400);
            }
            if ($app->status == "Accepted") {
                return response()->json([
                    "success" => false,
                    "message" => "Already Accepted",

                ], 400);
            }
            $validatedData = $request->validate([
                'statement' => 'required|string',

            ]);

            $app->update([
                'statement' => $validatedData["statement"],
                'status' => "Accepted"
            ]);

            Mail::to($app->jobseeker->email)->send(new AcceptedMail($app->jobseeker->firstname, $app->job->company->company_name, $app->job->title));
            return response()->json([
                "success" => true,
                "message" => "Application Accepted",
                "application" => $app

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
                "line" => $e->getLine()

            ], 400);
        }
    }
    public function getApps(Request $request)
    {

        try {
            $user =   $request->user();
          
            $company = Company::with('jobs.applications')->find($user->company->id);

          
            if (!$company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }
    
            $allApplications = [];
    
       
            foreach ($company->jobs as $job) {
                foreach ($job->applications as $application) {
                    $allApplications[] = [
                        'application_id' => $application->id,
                        'job_title' => $job->title,
                        'jobseeker' => $application->jobseeker,
                        'status' => $application->status,
                        'cover_letter' => url($application->cover_letter),
                        'cv' => url($application->cv),
                        'statement' => $application->statement,
                        'job' => $application->job,
                        'created_at' => $application->created_at,
                        'updated_at' => $application->updated_at
                    ];
                }
            }
    
       
          
            return response()->json([
                "success" => true,

                "applications" => $allApplications

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
    public function getAllApp(Request $request, $jobid)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $user->company->jobs->find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }

            $apps = $job->applications;
            if (!$apps || $apps->count() == 0) {
                return response()->json([
                    "success" => false,
                    "message" => "Application not found",

                ], 400);
            }
            $apps->transform(function ($a){
                $a->cv = url($a->cv);
                $a->cover_letter = url($a->cover_letter);
                return $a;
            });
            return response()->json([
                "success" => true,

                "applications" => $apps->load(['job', 'jobseeker'])

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
    public function getAppById(Request $request, $jobid, $appid)
    {
        try {
            $user =   $request->user();
            if (!$user->company) {
                return response()->json([
                    "success" => false,
                    "message" => "company not registerd"
                ], 400);
            }

            $job = $user->company->jobs->find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "Job not found",

                ], 400);
            }

            $app = $job->applications->find($appid);
            if (!$app) {
                return response()->json([
                    "success" => false,
                    "message" => "Application not found",

                ], 400);
            }
            $app->transform(function ($a){
                $a->cv = url($a->cv);
                $a->cover_letter = url($a->cover_letter);
                return $a;
            });
            return response()->json([
                "success" => true,

                "application" => $app->load('job')

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
