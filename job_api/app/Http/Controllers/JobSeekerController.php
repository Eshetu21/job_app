<?php

namespace App\Http\Controllers;

use App\Http\Requests\JobSeekerRequest\UpdateJobSeekerRequest;
use App\Models\JobSeeker;
use Exception;
use Illuminate\Http\Request;
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
                "created_by" => $user
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

    public function updatejobseeker(UpdateJobSeekerRequest $request, $id)
    {
        $user = $request->user();
        $jobseeker = JobSeeker::find($id);

        if (!$jobseeker) {
            return response()->json([
                "message" => "JobSeeker not found"
            ], 404);
        }
        $validatedData = $request->validated();
        if ($request->hasFile('cv')) {
            if ($jobseeker->cv && Storage::disk('public')->exists('CVs/' . $jobseeker->cv)) {
                Storage::disk('public')->delete($jobseeker->cv);
            }
            $cv = $request->file('cv');
            $cvName = time() . '.' . $cv->getClientOriginalExtension();
            $cvPath = $cv->storeAs('CVs', $cvName, 'public');
            $validatedData['cv'] = $cvPath;
        }
        try {

            $jobseeker->update($validatedData);
            $jobseeker->refresh();

            return response()->json([
                "message" => "Successfully updated",
                "jobseeker" => $jobseeker,
                "user" => $user
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                "error" => $e->getMessage(),
            ], 422);
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
}
