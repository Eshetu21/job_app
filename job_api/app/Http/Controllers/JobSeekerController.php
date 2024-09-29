<?php

namespace App\Http\Controllers;

use App\Http\Requests\JobSeekerRequest\UpdateJobSeekerRequest;
use App\Mail\ApplicationNotify;
use App\Models\Application;
use App\Models\Job;
use App\Models\JobSeeker;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Storage;

class JobSeekerController extends Controller
{
     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */

    public function createjobseeker(Request $request)
    {


        try {
            $user = $request->user();
            if ($user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "JobSeeker already exists"
                ], 400);
            }


            $jobseeker = JobSeeker::create([
                "user_id" => $user->id,
            ]);

            return response()->json([
                "success" => true,
                "message" => "Succesfully created",
                "jobseeker" => $jobseeker
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

     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */

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
        return response()->json([
            "success" => true,
            "message" => "Job seeker Deleted successfully",

        ], 200);
    }

     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */


    public function showjobseeker(Request $request)
    {
        try {
            $user = $request->user();
            $jobseeker = JobSeeker::with('user')->where('id', $user->jobseeker->id)->first();
            if (!$jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "not found"
                ]);
            }
            return response()->json([
                "success" => true,
                "jobseeker" => $jobseeker
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
     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */

    public function updatejobseeker(Request $request)
    {
        try {
            $user = $request->user();
            $jobseeker = $user->jobseeker;

            if (!$jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "JobSeeker not found"
                ], 404);
            }
            $validatedData = $request->validate([
                'category' => 'string|nullable',
                'sub_category' => 'string|nullable',
                'phone_number' => 'string|nullable',
                'about_me' => 'string|nullable',

            ]);

            // $updateData= [];
            // if ($request->hasFile('profile_pic')) {

            //     $profile_picLogoPath = public_path('uploads/job_seekers/profile_pic/' . $jobseeker->profile_pic);
            //     if (File::exists($profile_picLogoPath)) {
            //         File::delete($profile_picLogoPath);
            //     }
            //     $profile_pic = $request->file('profile_pic');
            //     $filenamep = time() . '_' . $profile_pic->getClientOriginalName();
            //     $profile_pic->move(public_path('uploads/job_seekers/profile_pic'), $filenamep);
            //     $updateData['profile_pic'] = public_path('uploads/job_seekers/profile_pic/').$filenamep;
            // }

            // $updateData = array_merge($updateData, [
            //     'category' => $validatedData['category'] ?? $jobseeker->category,
            //     'sub_category' => $validatedData['sub_category'] ?? $jobseeker->sub_category,
            //     'phone_number' => $validatedData['phone_number'] ?? $jobseeker->phone_number,
            //     'about_me' => $validatedData['about_me'] ?? $jobseeker->about_me,
            // ]);
            $jobseeker->update($validatedData);

            return response()->json([
                "success" => true,
                "message" => "Successfully updated",
                "jobseeker" => $jobseeker,
                "user" => $user
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

    // public function updatecv(Request $request)
    // {
    //     try {

    //         $user = $request->user();
    //         $jobseeker = $user->jobseeker;

    //         if (!$jobseeker) {
    //             return response()->json([
    //                 "success"=>false,
    //                 "message" => "JobSeeker not found"
    //             ], 404);
    //         }
    //         $validatedData = $request->validate([

    //             'cv' => 'mimes:pdf,doc|max:2048|nullable',
    //         ]);

    //         if ($request->hasFile('cv')) {

    //             $cvLogoPath = public_path('uploads/job_seekers/cv/' . $jobseeker->cv);
    //             if (File::exists($cvLogoPath)) {
    //                 File::delete($cvLogoPath);
    //             }
    //             $cv = $request->file('cv');
    //             $filename = time() . '_' . $cv->getClientOriginalName();
    //             $cv->move(public_path('uploads/job_seekers/cv'), $filename);
    //             $jobseeker->update(["cv" => $filename]);
    //         }

    //         return response()->json([
    //             "success"=>true,
    //             "message" => "CV successfully updated",
    //             "jobseeker" => $jobseeker,
    //             "user" => $user
    //         ], 200);
    //     } 

    //     catch (ValidationException $e) {
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


    // app
     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */

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

            $job = Job::find($jobid)->load(['privateclient', 'company']);
            if (!$job) {
                return response()->json([
                    "success" => false,
                    "message" => "No Job exist with this id",

                ], 401);
            }
            if ($user->privateclient) {
                if ($user->privateclient->id == $job->private_client_id) {
                    return response()->json([
                        "success" => false,
                        "message" => "You can not apply to your own job",

                    ], 401);
                }
            }
            if ($user->company) {
                if ($user->company->id == $job->company_id) {
                    return response()->json([
                        "success" => false,
                        "message" => "You can not apply to your own job",

                    ], 401);
                }
            }
            $application = Application::where(["job_id" => $jobid, "jobseeker_id" => $user->jobseeker->id])->first();


            if ($application) {
                return response()->json([
                    "success" => false,
                    "message" => "You have already applied to this Job",

                ], 401);
            }


            $request->validate([
                'cover_letter' => 'required|mimes:pdf,doc|max:2048',
                'cv' => 'required|mimes:pdf,doc|max:2048'
            ]);



            $cv = $request->file('cv');

            $originalfilenamecv = $cv->getClientOriginalName();
            $filename = time() . "-" . $user->jobseeker->id . "-" . $job->id . $originalfilenamecv;
            $cv->move(public_path('uploads/application/cv'), $filename);
            $cv =  'uploads/application/cv/' . $filename;

            $cover_letter = $request->file('cover_letter');

            $originalfilenamecl = $cover_letter->getClientOriginalName();
            $filename = time() . "-" . $user->jobseeker->id . "-" . $job->id . $originalfilenamecl;
            $cover_letter->move(public_path('uploads/application/cover_letter'), $filename);
            $cover_letter =  'uploads/application/cover_letter/' . $filename;
            $application = Application::create([
                'job_id' => $jobid,
                'jobseeker_id' => $user->jobseeker->id,
                'cover_letter' => $cover_letter,
                'cv' => $cv
            ]);

            if ($job->company) {
                $username =  $user->firstname . " " .  $user->lastname;
                Mail::to($job->company->user->email)->send(new ApplicationNotify($username, $job->company->company_name, $job->title));
            } else if ($job->privateclient) {
                $username =  $user->firstname . " " .  $user->lastname;
                Mail::to($job->privateclient->user->email)->send(new ApplicationNotify($username, "Private Client", $job->title));
            }

            if ($application) {
                return response()->json([
                    "success" => true,
                    "message" => "Job Applied successfully",

                ], 200);
            }
        } catch (ValidationException $e) {
            return response()->json([
                "success" => false,
                "message" => $e->errors(),


            ], 400);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
                'line' => $e->getLine()

            ], 400);
            
        }
    }
    /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */

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

            $application = Application::where(["jobseeker_id" => $user->jobseeker->id])
                ->with('job')
                ->get();
            if (!$application || $application->count() == 0) {
                return response()->json([
                    "success" => false,
                    "message" => "No applications found",

                ], 401);
            }
            $application->transform(function ($app) {
                $app->cv = url($app->cv);
                $app->cover_letter = url($app->cover_letter);
                return $app;
            });
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

     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */


    public function deleteApplication(Request $request, $appid)
    {
        try {
            $user = $request->user();
            if (!$user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "Jobseeker not registered"
                ], 400);
            }
            $application = Application::where('jobseeker_id', $user->jobseeker->id)
                ->where('id', $appid)
                ->first();
            if (!$application) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found"
                ], 404);
            }
            if (File::exists($application->cv)) {
                File::delete($application->cv);
            }
            if (File::exists($application->cover_letter)) {
                File::delete($application->cover_letter);
            }
            $application->delete();
            return response()->json([
                "success" => true,
                "message" => "Application deleted"
            ], 200);
        } catch (Exception $e) {

            return response()->json([
                "success" => false,
                "message" => $e->getMessage()
            ], 500);
        }
    }
     /**
     * get all applicaton
     * @response {
     * "name": "eyob bm"}
     */

    public function getapplication(Request $request, $appid)
    {
        try {
            $user = $request->user();
            if (!$user->jobseeker) {
                return response()->json([
                    "success" => false,
                    "message" => "Jobseeker not registered"
                ], 400);
            }
            $application = Application::where('jobseeker_id', $user->jobseeker->id)
                ->where('id', $appid)
                ->first();
            if (!$application) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found"
                ], 404);
            }
            $application->transform(function ($app) {
                $app->cv = url($app->cv);
                $app->cover_letter = url($app->cover_letter);
                return $app;
            });
            return response()->json([
                "success" => true,
                "application" => $application
            ], 200);
        } catch (Exception $e) {

            return response()->json([
                "success" => false,
                "message" => $e->getMessage()
            ], 500);
        }
    }
    /*   public function updateApplication(Request $request, $appid)
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
    } */
}
