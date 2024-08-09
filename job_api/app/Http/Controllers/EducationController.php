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

    public function showeducation(Request $request)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        if (!$jobseeker) {
            return response()->json([
                "message" => "Jobseeker not found"
            ]);
        }
        $education = $jobseeker->educations;
        if (!$education) {
            return response()->json([
                "message" => "Education not found"
            ]);
        }
        return response()->json([
            "education" => $education
        ], 200);
    }
    public function addeducation(StoreEductionRequest $request, $jobseekerId)
    {
        $user = Auth::user();

        try {
            $validatedData = $request->validated();
            $validatedData["job_seeker_id"] = $jobseekerId;
            $education = Education::firstOrCreate($validatedData);
                return response()->json(
                [
                    "message" => "Education added sucessfully",
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

    public function updateeducation(StoreEductionRequest $request, $jobseekerId, $educationId)
    {
        $user = $request->user();
        $jobseeker = JobSeeker::where('id', $jobseekerId)->where('user_id', $user->id)->first();
        if (!$jobseeker) {
            return response()->json([
                "message" => "jobseeker not found"
            ]);
        }
        $education = $jobseeker->educations()->where("id", $educationId)->first();
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
                "education" => $education,
                "Jobseeker" => $jobseeker
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
