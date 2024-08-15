<?php

namespace App\Http\Controllers;

use App\Http\Requests\SkillRequest\StoreSkillRequest;
use App\Models\JobSeeker;
use App\Models\Skill;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class SkillController extends Controller
{
    public function showskill(Request $request)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        $skill = $jobseeker->skills;

        if (!$skill) {
            return response()->json([
                "message" => "No skills"
            ], 404);
        }
        return response()->json([
            "skills" => $skill
        ], 200);
    }

    public function updateskill(StoreSkillRequest $request, $jobseekerId)
    {
        $user = Auth::user();
        $validatedData = $request->validated();
        $newSkills = $validatedData['skills'];
        $jobseeker = JobSeeker::find($jobseekerId);
        if (!$jobseeker) {
            return response()->json(["message" => "Job Seeker not found"], 404);
        }
        $existingSkills = Skill::where('job_seeker_id', $jobseekerId)->first();
        if (!$existingSkills) {
            $existingSkills = new Skill();
            $existingSkills->job_seeker_id = $jobseekerId;
        }
        $existingSkills->skills = json_encode(array_values($newSkills));
        $existingSkills->save();
        return response()->json([
            "skills" => json_decode($existingSkills->skills, true)
        ], 200);
    }

    /*  public function updateskill(StoreSkillRequest $request, $jobseekerId, $index)
    {
        $user = $request->user();
        $jobseeker = JobSeeker::where("id", $jobseekerId)->where("user_id", $user->id)->first();

        if (!$jobseeker) {
            return response()->json(["message" => "Job Seeker not found"], 404);
        }

        $existingSkills = Skill::where('job_seeker_id', $jobseekerId)->first();

        if (!$existingSkills) {
            $existingSkills = new Skill();
            $existingSkills->job_seeker_id = $jobseekerId;
            $existingSkills->skills = json_encode([]);
        }

        $skillsArray = json_decode($existingSkills->skills, true);

        if (!isset($skillsArray[$index])) {
            return response()->json([
                "message" => "Skill not found at the given index"
            ], 404);
        }

        try {
            $skillsArray[$index] = $request->validated()['skills'];
            $existingSkills->skills = json_encode($skillsArray);
            $existingSkills->save();

            return response()->json([
                "message" => "Successfully updated skill",
                "skills" => $skillsArray
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                "message" => "Failed to validate"
            ], 422);
        }
    }

    public function deleteskill(Request $request, $jobseekerId, $index)
    {
        $user = $request->user();
        $jobseeker = JobSeeker::where("id", $jobseekerId)->where("user_id", $user->id)->first();

        if (!$jobseeker || !$jobseeker->skills) {
            return response()->json([
                "message" => "No skill found"
            ], 404);
        }

        $skillsArray = json_decode($jobseeker->skills, true);

        if (!isset($skillsArray[$index])) {
            return response()->json([
                "message" => "Skill not found at the given index"
            ], 404);
        }

        array_splice($skillsArray, $index, 1);
        $jobseeker->skills = json_encode($skillsArray);
        $jobseeker->save();

        return response()->json([
            "message" => "Deleted successfully",
            "skills" => $skillsArray
        ], 200);
    } */
}
