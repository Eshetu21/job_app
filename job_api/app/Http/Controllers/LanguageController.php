<?php

namespace App\Http\Controllers;

use App\Http\Requests\LanguageRequest\StoreLanguageRequest;
use App\Models\JobSeeker;
use App\Models\Language;
use Illuminate\Http\Request;

class LanguageController extends Controller
{
    public function showlanguage(Request $request)
    {
        $user = $request->user();
        $jobseeker = $user->jobseeker;
        $language = $jobseeker->languages;
        if (!$language) {
            return response()->json([
                "message" => "No language"
            ]);
        }
        return response()->json([
            "language" => $language
        ], 200);
    }

    public function updatelanguage(StoreLanguageRequest $request, int $JobSeekerId)
    {
        $validatedData = $request->validated();
        $newLanguage = $validatedData["languages"];
        $jobseeker = JobSeeker::find($JobSeekerId);
        if (!$jobseeker) {
            return response()->json([
                "message" => "jobseeker not found"
            ]);
        }
        $existingLanguage = Language::where("job_seeker_id", $JobSeekerId)->first();
        if (!$existingLanguage) {
            $existingLanguage = new Language();
            $existingLanguage->job_seeker_id = $JobSeekerId;
        }
        $existingLanguage->languages = json_encode(array_values($newLanguage));
        $existingLanguage->save();
        return response()->json([
            "message" => "sucessfully added language",
            "languages"=>json_decode($existingLanguage->languages, true)
        ], 200);
    }
}
