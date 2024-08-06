<?php

namespace App\Http\Controllers;

use App\Models\PrivateClient;
use Illuminate\Http\Request;

class PrivateClientController extends Controller
{
    public function createprivateclient(Request $request)
    {
        $user = $request->user();
        if ($user->PrivateClient) {
            return response()->json([
                "message" => "PrivateClient already exists"
            ], 400);
        }
        $validatedData = $request->validate(
            ["profile_pic" => "nullable|string"]
        );
        $privateclient = PrivateClient::create([
            'profile_pic' => $validatedData["profile_pic"],
            'user_id' => $user->id
        ]);
        return response()->json([
            'message' => 'Private client profile created successfully.',
            'private_client' => $privateclient,
        ], 201);
    }

    public function privatecreatejob(Request $request)
    {
        $user = $request->user();
        if (!$user->privateclient) {
            return response()->json([
                "message" => "not private client"
            ], 400);
        }
        $validatedData = $request->validate([
            'job_title' => 'required|string|max:255',
            'job_location' => 'required|string|max:255',
            'job_salary' => 'nullable|numeric',
            'job_start_date' => 'required|date',
            'job_end_date' => 'required|date|after_or_equal:job_start_date',
            'job_description' => 'required|string',
        ]);
        $validatedData['private_client_id'] = $user->privateclient->id;
        $job = $user->privateclient->jobs()->create(
            $validatedData
        );
        $user->privateclient->load('user');
        return response()->json([
            "message" => "job created sucessfully",
            "job" => $job,
            "creater" => $user->privateclient
        ], 201);
    }
}
