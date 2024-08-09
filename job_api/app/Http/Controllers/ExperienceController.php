<?php

namespace App\Http\Controllers;

use App\Http\Requests\ExperienceRequest\StoreExperienceRequest;
use App\Models\Experience;
use Illuminate\Auth\Events\Validated;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class ExperienceController extends Controller
{
    public function showexperience(Request $request)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        if (!$jobseeker) {
            return response()->json([
                "message" => "jobseeker not found"
            ]);
        }
        $experience = $jobseeker->experiences;
        if (!$experience) {
            return response()->json([
                "message" => "no experience"
            ]);
        }
        return response()->json([
            "experience" => $experience,
            "jobseeker" => $jobseeker
        ], 200);
    }

    public function addexperience(StoreExperienceRequest $request, $jobseekerid)
    {
        $user = Auth::user();
        try {
            $validatedData = $request->validated();
            $validatedData["job_seeker_id"] = $jobseekerid;
            $experience = Experience::firstOrCreate($validatedData);
            return response()->json([
                "message" => "Experience added",
                "expereince" => $experience,
                "jobseeker" => $user->jobseeker
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                "message" => "validation failed"
            ], 422);
        }
    }
}
