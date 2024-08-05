<?php

namespace App\Http\Controllers;

use App\Http\Requests\EducationRequest\StoreEductionRequest;
use App\Models\Education;
use App\Models\JobSeeker;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class EducationController extends Controller
{

    public function showeducation(Request $request, $id)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        if (!$jobseeker) {
            return response()->json([
                "message" => "Jobseeker not found"
            ]);
        }
        $education = $jobseeker->educations()->where("id", $id)->first();
        if (!$education) {
            return response()->json([
                "message" => "Education not found"
            ]);
        }
        return response()->json([
            "education" => $education
        ]);
    }
    public function addeducation(StoreEductionRequest $request)
    {
        $user = Auth::user();
        $jobseeker = JobSeeker::where("user_id", $user->id)->first();
        try {
            $validatedData = $request->validated();
            $validatedData["job_seeker_id"] = $jobseeker->id;
            $education = Education::create($validatedData);

            return response()->json(
                [
                    "message" => "Education added sucessfully",
                    "jobseeker" => $jobseeker,
                    "education" => $education

                ],
                201
            );
        } catch (ValidationException $e) {
            return response()->json(
                [
                    "message" => "Validation failed"
                ],
                422
            );
        }
    }

    public function updateeducation(StoreEductionRequest $request, $id)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        if (!$jobseeker) {
            return response()->json([
                "message" => "jobseeker not found"
            ]);
        }
        $education = $jobseeker->educations()->where("id", $id)->first();
        if (!$education) {
            return response()->json([
                "message" => "education not found"
            ]);
        }
        try {
            $validatedData = $request->validated();
            $education->update($validatedData);
            return response()->json([
                "message" => "sucessfully updated",
                "education" => $education
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                "message" => "validation failed"
            ]);
        }
    }
    public function deleteeducation(Request $request, $id)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        if (!$jobseeker) {
            return response()->json([
                "message" => "jobseeker not found"
            ]);
        }
        $education = $jobseeker->educations()->where("id", $id)->first();
        if (!$education) {
            return response()->json([
                "message" => "Education not found"
            ]);
        }
        $education->delete();
        return response()->json([
            "message" => "deleted sucessfully"
        ]);
    }
}
