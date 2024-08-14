<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserRequest\LoginRequest;
use App\Http\Requests\UserRequest\RegisterRequest;
use App\Http\Requests\UserRequest\UpdateRequest;
use App\Models\User;
use Dotenv\Exception\ValidationException as ExceptionValidationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;



class UserController extends Controller
{

    public function getuserprofile()
    {
        $user = Auth::user();
        $profiles = [
            'jobseeker' => $user->jobseeker ? $user->jobseeker->load('user') : null,
            'privateclient' => $user->privateclient ? $user->privateclient->load('user') : null,
            'company' => $user->company ? $user->company->load('user') : null,
        ];

        return response()->json(['profiles' => $profiles], 200);
    }

    public function register(RegisterRequest $request)
    {
        $validatedData = $request->validated();
        try {
            $user = User::create([
                "firstname" => $validatedData["firstname"],
                "lastname" => $validatedData["lastname"],
                "email" => $validatedData["email"],
                "address" => $validatedData["address"],
                "password" => Hash::make($validatedData["password"])
            ]);
            $token = $user->createToken("job_portal")->plainTextToken;
            return response()->json([
                "name" => $user->firstname . " " . $user->lastname,
                "token" => $token
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                "message" => "Validation Failed",
                "errors" => $e->errors()
            ], 422);
        }
    }

    public function login(LoginRequest $request)
    {
        $validatedData = $request->validated();
        $user = User::whereemail($request->email)->first();
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                "error" => "Invalid Credientials"
            ], 401);
        }

        $token = $user->createToken("job_portal")->plainTextToken;
        return response()->json([
            "message" => $user,
            "token" => $token
        ], 200);
    }


    public function update(UpdateRequest $request)
    {
        $user = $request->user();
        $validatedData = $request->validated();
       
        try {
            $user->update([
                "firstname" => $validatedData["firstname"] ?? $user->firstname,
                "lastname" => $validatedData["lastname"] ?? $user->lastname,
                "email" => $validatedData["email"] ?? $user->email,
                "age" => $validatedData["age"] ?? $user->age,
                "gender" => $validatedData["gender"] ?? $user->gender,
                "profile_pic" => $validatedData["profile_pic"] ?? $user->profile_pic,
                "about_me" => $validatedData["about_me"] ?? $user->about_me,
              
            ]);
        } catch (ExceptionValidationException $e) {
        }
        return response()->json([
            "message" => "Data updated successfully",
            "user" => $user
        ], 200);
    }

    public function delete(Request $request)
    {

        $request->user()->delete();

        $user = $request->user();
        $user->delete();

        return response()->json([
            "message" => "No content"
        ]);
    }
}
