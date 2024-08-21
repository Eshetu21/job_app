<?php

namespace App\Http\Controllers;

use App\Models\PrivateClient;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PrivateClientController extends Controller
{   public function showprivateclient(Request $request){
    $user = $request->user();
    $privateclient = PrivateClient::with('user')->where("user_id",$user->id)->first();
        if (!$user->privateclient) {
            return response()->json([
                "message" => "PrivateClient doesn't exists"
            ], 400);
        }
        return response()->json([
            "privateclient"=>$privateclient
        ],200);
}
    public function createprivateclient(Request $request)
    {
        $user = $request->user();
        if ($user->privateclient) {
            return response()->json([
                "message" => "PrivateClient already exists"
            ], 400);
        }
        $validatedData = $request->validate(
            ["profile_pic" => "nullable|string"]
        );
        $profile_pic = $validatedData["profile_pic"] ?? null;
        $privateclient = PrivateClient::create([
            'profile_pic' => $profile_pic,
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
            'deadline' => 'required|date|',
            'job_description' => 'required|string',
        ]);

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

    public function update(Request $request)
    {
        $user = $request->user();
        if (!$user->privateclient) {
            return response()->json([
                "success" => false,
                "message" => "privateclient not registerd"
            ], 400);
            try {
                $user->privateclient->update([


                    "profile_pic" => $request->profile_pic ?? $user->profile_pic,
                ]);
            } catch (Exception $e) {
                return response()->json([
                    "success" => false,
                    "message" => $e->getMessage(),

                ], 400);
            }
            return response()->json([
                "message" => "Data updated successfully",
                "privateclient" => $user->privateclient
            ], 200);
        }
    }

    public function delete(Request $request)
    {

        $user =   $request->user();
        if (!$user->privateclient) {
            return response()->json([
                "success" => false,
                "message" => "privateclient not registerd"
            ], 400);
        }

        try {
            $user->privateclient->delete();
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
        return response()->json([
            "success" => true,
            "message" => "Private Client Deleted successfully",

        ], 200);
    }
}
