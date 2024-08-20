<?php

namespace App\Http\Controllers;

use App\Http\Requests\JobSeekerRequest\UpdateJobSeekerRequest;
use App\Models\Application;
use App\Models\Job;
use App\Models\JobSeeker;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Storage;


class JobSeekerController extends Controller
{
    public function createjobseeker(Request $request)
    {
        $user = $request->user();
        if ($user->JobSeeker) {
            return response()->json([
                "message" => "JobSeeker already exists"
            ], 400);
        }

        try {
            $jobseeker = JobSeeker::create([
                "user_id" => $user->id,
            ]);

            return response()->json([
                "message" => "Succesfully created",
                "jobseeker" => $jobseeker
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                "errors" => $e->errors()
            ], 422);
        }
    }

    public function showjobseeker(Request $request)
    {
        $user = $request->user();
        $jobseeker = JobSeeker::with('user')->where('user_id', $user->id)->first();
        if (!$jobseeker) {
            return response()->json([
                "error" => "not found"
            ]);
        }
        return response()->json([
            "jobseeker" => $jobseeker
        ], 200);
    }

    public function updatejobseeker(Request $request)
    {
try{
        $user = $request->user();

        $jobseeker =  $user->jobseeker;

        if (!$jobseeker) {
            return response()->json([
                "message" => "JobSeeker not found"
            ], 404);
        }
        $validatedData = $request->validate([
            'category' => 'string',
            'sub_category' => 'string',
       
            'phone_number' => 'string',
            'about_me' => 'string'
        ]);
       
        if ($request->has('cv')) {
            $request->validate([
               "cv" => "mimes:pdf,doc|max:2048",
            ]);
            if($jobseeker->cv){
                $cvLogoPath = public_path('uploads/cv/' . $jobseeker->cv);
        
                    
                if (File::exists($cvLogoPath)) {
                    File::delete($cvLogoPath);
                }
            }
            $cv = $request->file('cv');
            $extention = $cv->getClientOriginalExtension();
            $originalfilename = $cv->getClientOriginalName();
            $filename = time() . $originalfilename . "." .$extention;
            $cv->move(public_path('uploads/cv'), $filename);
            $jobseeker->update(['cv'=>$filename]);
        }
        if ($request->has('profile_pic')) {
            $request->validate([
               "profile_pic" => "mimes:png,jpg,jpeg|max:2048",
            ]);
            if($jobseeker->profile_pic){
                $profile_picLogoPath = public_path('uploads/profile_pic/' . $jobseeker->profile_pic);
        
                    
                if (File::exists($profile_picLogoPath)) {
                    File::delete($profile_picLogoPath);
                }
            }
            $profile_pic = $request->file('profile_pic');
            $extention = $profile_pic->getClientOriginalExtension();
            $originalfilename = $profile_pic->getClientOriginalName();
            $filename = time() . $originalfilename . "." .$extention;
            $profile_pic->move(public_path('uploads/profile_pic'), $filename);
            $jobseeker->update(['profile_pic'=>$filename]);
        }
      
        

            $jobseeker->update([
                'category' => isset($validatedData["category"])? $validatedData["category"]:$jobseeker->category,
                'sub_category' => isset($validatedData["sub_category"])? $validatedData["sub_category"]:$jobseeker->sub_category,
           
                'phone_number' => isset($validatedData["phone_number"])? $validatedData["phone_number"]:$jobseeker->phone_number,
                'about_me' => isset($validatedData["about_me"])? $validatedData["about_me"]:$jobseeker->about_me
            ]);

            return response()->json([
                "message" => "Successfully updated",
                "jobseeker" => $jobseeker,
                "user" => $user
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

        $user =   $request->user();
        if (!$user->jobseeker) {
            return response()->json([
                "success" => false,
                "message" => "jobseeker not registerd"
            ], 400);
        }

        try {
            $user->jobseeker->delete();
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
        return response()->json([
            "success" => true,
            "message" => "Job Seeker Deleted successfully",

        ], 200);
    }



    // application

    public function applyJob(Request $request, $jobid)
    {
        try {
            $user = $request->user();
            if (!$user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "jobseeker not registerd"
                ], 400);
            }
            $job = Job::find($jobid);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "No Job exist with this id",

                ], 401);
            }
            $request->validate([
                'cover_letter' => 'required|mimes:pdf,doc|max:2048'
            ]);

            if ($request->has('cover_letter')) {
                $cover_letter = $request->file('cover_letter');
                $extention = $cover_letter->getClientOriginalExtension();
                $originalfilename = $cover_letter->getClientOriginalName();
                $filename = time() . $originalfilename . "." . $extention;
                $cover_letter->move(public_path('uploads/cover_letters'), $filename);
            }


            $application = Application::where(["job_id" => $jobid, "user_id" => $user->id])->first();

            if ($application) {
                return response()->json([
                    "success" => false,
                    "message" => "You already applied to this Job",

                ], 401);
            }






            $application = Application::create([
                'job_id' => $jobid,
                'user_id' => $user->id,
                'cover_letter' => $filename
            ]);

            if ($application) {
                return response()->json([
                    "success" => true,
                    "message" => "Job Applied successfully",

                ], 200);
            }
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }
    public function getApplications(Request $request)
    {
        try {

            $user = $request->user();
            if (!$user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "jobseeker not registerd"
                ], 400);
            }

            $application = Application::where(["user_id" => $user->id])->get()->load(['job']);
            if (!$application) {
                return response()->json([
                    "success" => false,
                    "message" => "No applications found",

                ], 401);
            }
            return response()->json([
                "success" => true,
                "applications" => $application,

            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }



    public function deleteApplication(Request $request, $appid)
    {
        try {




            $user = $request->user();
            if (!$user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "jobseeker not registerd"
                ], 400);
            }

            $application = Application::find($appid);
            if (!$application) {
                return response()->json([
                    "success" => false,
                    "message" => "No applications found",

                ], 401);
            }
            $coverLetterPath = public_path('uploads/cover_letters' . $application->cover_letter);
            if (File::exists($coverLetterPath)) {

                File::delete($coverLetterPath);
            }
            $application->delete();

            return response()->json([
                "success" => true,
                "message" => "Application deleted",

            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
    }


    public function updateApplication(Request $request, $appid)
    {
        try {
            $user = $request->user();
            if (!$user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "Jobseeker not registered"
                ], 400);
            }


            $application = Application::find($appid);
            if (!$application) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found"
                ], 404);
            }


            $request->validate([
                'cover_letter' => 'nullable|mimes:pdf,doc|max:2048'
            ]);


            if ($request->has('cover_letter')) {

                $coverLetterPath = public_path('uploads/cover_letters' . $application->cover_letter);
                if (File::exists($coverLetterPath)) {
                    File::delete($coverLetterPath);
                }


                $cover_letter = $request->file('cover_letter');
                $extention = $cover_letter->getClientOriginalExtension();
                $originalfilename = $cover_letter->getClientOriginalName();
                $filename = time() . $originalfilename . "." . $extention;
                $cover_letter->move(public_path('uploads'), $filename);

                $application->update(['cover_letter' => $filename]);
            }

            return response()->json([
                "success" => true,
                "message" => "Application updated successfully"
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage()
            ], 400);
        }
    }
}
