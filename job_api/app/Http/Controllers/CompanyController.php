<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\Job;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Validator;

class CompanyController extends Controller
{

    public function createcompany(Request $request)
    {

        try {
            $user = $request->user();
            if ($user->Company) {
                return response()->json([
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
                $extention = $company_logo->getClientOriginalExtension();
                $originalfilename = $company_logo->getClientOriginalName();
                $filename = time() . $originalfilename . "." . $extention;
                $company_logo->move(public_path('uploads/company_logo'), $filename);
                $validatedData["user_id"] = $user->id;
                $validatedData["company_logo"] = $filename;
                $company = Company::create($validatedData);
            }
            return response()->json([
                'message' => 'Company profile created successfully.',
                'company' => $company
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
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

                $companyLogoPath = public_path('uploads/company_logo/' . $company->company_logo);
                if (File::exists($companyLogoPath)) {
                    File::delete($companyLogoPath);
                }
                $companyLogo = $request->file('company_logo');
                $filename = time() . '_' . $companyLogo->getClientOriginalName();
                $companyLogo->move(public_path('uploads/company_logo'), $filename);
                $company->update(['company_logo' => $filename]);
            }
            $company->update([
                "company_name" => $validatedData->getData()["company_name"] ?? $company->company_name,
                "company_phone" => $validatedData->getData()["company_phone"] ?? $company->company_phone,
                "company_address" => $validatedData->getData()["company_address"] ?? $company->company_address,
                "company_description" => $validatedData->getData()["company_description"] ?? $company->company_description,
            ]);

            return response()->json([
                "message" => "Data updated successfully",
                "updatedCompany" => $company,
            ], 200);
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
            $companyLogoPath = public_path('uploads/cover_letters' . $company->cover_letter);
            if (File::exists($companyLogoPath)) {

                File::delete($companyLogoPath);
            }
            $user->company->delete();
            return response()->json([
                "success" => true,
                "message" => "Company Deleted successfully",

            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }
    public function companycreatejob(Request $request)
    {
        try {
            $user = $request->user();
            if (!$user->company) {
                return response()->json([
                    "message" => "company not registerd"
                ], 400);
            }
            $validatedData = $request->validate([
                'job_title' => 'required|string|max:255',
                'job_location' => 'required|string|max:255',
                'job_salary' => 'nullable|numeric',

                'deadline' => 'required|date',
                'job_description' => 'required|string',
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
                'job_title' => 'string|max:255',
                'job_location' => 'string|max:255',
                'job_salary' => 'nullable|numeric',

                'deadline' => 'date',
                'job_description' => 'string',
            ]);

            $job->update([
                'job_title' => isset($validatedData["job_title"]) ? $validatedData["job_title"] : $job->job_title,
                'job_location' => isset($validatedData["job_location"]) ? $validatedData["job_location"] : $job->job_location,
                'job_salary' => isset($validatedData["job_salary"]) ? $validatedData["job_salary"] : $job->job_salary,

                'deadline' => isset($validatedData["deadline"]) ? $validatedData["deadline"] : $job->deadline,
                'job_description' => isset($validatedData["job_description"]) ? $validatedData["job_description"] : $job->job_description,
            ]);
            return response()->json([
                "success" => true,
                "message" => "Job Updated successfuly",
                "updatedjob" => $job

            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }
    public function getJobbyId(Request $request, $jobid)
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
            return response()->json([
                "success" => true,
                "job" => $job

            ], 200);
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
            $validatedData = $request->validate([
                'statement' => 'string',

            ]);

            $app->update([
                'statement' => isset($validatedData["statement"]) ? $validatedData["statement"] : null,
                'status' => "Rejected"
            ]);
            return response()->json([
                "success" => true,
                "message" => "Application Rejected",
                "application" => $app

            ], 200);
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
            $validatedData = $request->validate([
                'statement' => 'required|string',

            ]);

            $app->update([
                'statement' => $validatedData["statement"],
                'status' => "Accepted"
            ]);
            return response()->json([
                "success" => true,
                "message" => "Application Accepted",
                "application" => $app

            ], 200);
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
            return response()->json([
                "success" => true,

                "applications" => $apps

            ], 200);
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

            return response()->json([
                "success" => true,

                "application" => $app

            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }
}
