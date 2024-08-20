<?php

namespace App\Http\Controllers;

use App\Http\Requests\SkillRequest\StoreSkillRequest;
use App\Models\JobSeeker;
use App\Models\Skill;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


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
}
