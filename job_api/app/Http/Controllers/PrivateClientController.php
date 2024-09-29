<?php

namespace App\Http\Controllers;

use App\Mail\AcceptedMail;
use App\Mail\RejectedMail;
use App\Models\PrivateClient;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class PrivateClientController extends Controller
{
    public function showprivateclient(Request $request)
    {
        try {

            $user = $request->user();
            $privateclient = PrivateClient::with('user')->where("user_id", $user->id)->first();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "PrivateClient doesn't exists"
                ], 400);
            }
            return response()->json([
                "success" => true,
                "privateclient" => $privateclient
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
    public function createprivateclient(Request $request)
    {

        try {
            $user = $request->user();
            if ($user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "PrivateClient already exists"
                ], 400);
            }
            $validatedData = $request->validate(
                ["profile_pic" => "nullable|string"]
            );
            $profile_pic = $validatedData["profile_pic"] ?? null;
            $privateclient = PrivateClient::create([
                'profile_pic' => $profile_pic,
                'user_id' => $user->id
            ]);
            return response()->json([
                "success" => true,
                'message' => 'Private client profile created successfully.',
                'private_client' => $privateclient,
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

    public function privatecreatejob(Request $request)
    {

        try {

            $user = $request->user();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "not private client"
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

            $job = $user->privateclient->jobs()->create(
                $validatedData
            );
            $user->privateclient->load('user');
            return response()->json([
                "success" => true,
                "message" => "job created sucessfully",
                "job" => $job,
                "creater" => $user->privateclient
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

    public function update(Request $request)
    {
        try {
            $user = $request->user();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }
            $validatedData = Validator::make($request->all(), [
                "profile_pic" => "nullable|mimes:png,jpg,jpeg|max:2048",

            ]);

            if ($validatedData->fails()) {
                return response()->json([
                    "success" => false,
                    "message" => $validatedData->errors(),
                ], 400);
            }

            $privateclient = $user->privateclient;

            if ($request->hasFile('profile_pic')) {

                $privateclientpicPath = public_path('uploads/profile_pic/' . $privateclient->profile_pic);
                if (File::exists($privateclientpicPath)) {
                    File::delete($privateclientpicPath);
                }
                $privateclientpic = $request->file('profile_pic');
                $filename = time() . '_' . $privateclientpic->getClientOriginalName();
                $privateclientpic->move(public_path('uploads/profile_pic'), $filename);
                $privateclient->update(['profile_pic' => $filename]);
                $privateclient->save();
            }

            return response()->json([
                "success" => true,
                "message" => "Data updated successfully",
                "updatedprivateclient" => $privateclient,
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

        $user =   $request->user();

        if (!$user->privateclient) {
            return response()->json([
                "success" => false,
                "message" => "privateclient not registerd"
            ], 400);
        }

        try {
            $privateclient = $user->privateclient;
            $privateclientpicPath = public_path('uploads/profile_pic/' . $privateclient->profile_pic);
            if (File::exists($privateclientpicPath)) {
                File::delete($privateclientpicPath);
            }
            $user->privateclient->delete();
            return response()->json([
                "success" => true,
                "message" => "Private Client Deleted successfully",

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
    public function privateclientcreatejob(Request $request)
    {
        try {
            $user = $request->user();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
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
            $validatedData['privateclient_id'] = $user->privateclient->id;
            $job = $user->privateclient->jobs()->create(
                $validatedData
            );
            $user->privateclient->load('user');
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
        } catch (ValidationException $e) {
            return response()->json([
                "success" => false,
                "message" => $e->errors(),
            ], 400);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
            ], 500);
        }
    }

    public function getMyJobs(Request $request)
    {
        $user =   $request->user();
        if (!$user->privateclient) {
            return response()->json([
                "success" => false,
                "message" => "privateclient not registerd"
            ], 400);
        }
        try {
            $jobs = $user->privateclient->jobs;
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
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }

            $job = $user->privateclient->jobs->find($jobid);
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
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }

            $job = $user->privateclient->jobs->find($jobid);
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
    public function getJobbyId(Request $request, $jobid)
    {
        try {
            $user =   $request->user();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }

            $job = $user->privateclient->jobs->find($jobid);
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
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }

            $job = $user->privateclient->jobs->find($jobid);
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
            if($app->status=="Rejected"){
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
            Mail::to($app->jobseeker->email)->send(new RejectedMail($app->jobseeker->firstname,"Private Client",$app->job->title));
            return response()->json([
                "success" => true,
                "message" => "Application Rejected",
                "application" => $app

            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                "success" => false,
                "message" => $e->errors(),
              

            ], 400);} catch (Exception $e) {
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
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }
            
            $job = $user->privateclient->jobs->find($jobid);
          
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
            if($app->status=="Accepted"){
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
            
            Mail::to($app->jobseeker->email)->send(new AcceptedMail($app->jobseeker->firstname,"Private Client",$app->job->title));
            return response()->json([
                "success" => true,
                "message" => "Application Accepted",
                "application" => $app

            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                "success" => false,
                "message" => $e->errors(),
              

            ], 400);} catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
                "line"=>$e->getLine()

            ], 400);
        }
    }
    public function getAllApp(Request $request, $jobid)
    {
        try {
            $user =   $request->user();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }

            $job = $user->privateclient->jobs->find($jobid);
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

                "applications" => $apps->load('job')

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

    public function getAppsP(Request $request)
    {

        try {
            $user =   $request->user();
          
            $privateclient = Privateclient::with('jobs.applications')->find($user->privateclient->id);

          
            if (!$privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }
    
            $allApplications = [];
    
       
            foreach ($privateclient->jobs as $job) {
                foreach ($job->applications as $application) {
                    
                    $allApplications[] = [
                        'application_id' => $application->id,
                        'job_title' => $job->title,
                        'jobseeker' => $application->jobseeker,
                        'user' => $application->jobseeker->user,
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
    public function getAppById(Request $request, $jobid, $appid)
    {
        try {
            $user =   $request->user();
            if (!$user->privateclient) {
                return response()->json([
                    "success" => false,
                    "message" => "privateclient not registerd"
                ], 400);
            }

            $job = $user->privateclient->jobs->find($jobid);
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
