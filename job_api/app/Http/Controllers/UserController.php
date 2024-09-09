<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserRequest\LoginRequest;
use App\Http\Requests\UserRequest\RegisterRequest;
use App\Http\Requests\UserRequest\UpdateRequest;
use App\Mail\SendPin;
use App\Models\User;
use Carbon\Carbon;
use Dotenv\Exception\ValidationException as ExceptionValidationException;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
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
    public function changepassword(Request $request)
    {
        try {
            $user = $request->user();
            $request->validate(['oldpassword' => 'required|string|min:6', "newpassword" => 'required|string|min:6']);
            if (Hash::check($request->oldpassword, $user->password)) {
                $user->update(['password' => Hash::make($request->newpassword)]);
                $user->save();
                return response()->json([
                    "success" => true,
                    "message" => "Password Updated",

                ], 200);
            } else {
                return response()->json([
                    "success" => false,
                    "message" => "Old password is incorrect",

                ], 400);
            }
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500);
        }
    }

    public function checkpincode(Request $request)
    {
        $user = $request->user();
        if ($user->email_verified) {
            return response()->json([
                "success" => false,
                "message" => "You already verified",

            ], 400);
        }


        $request->validate([
            'pincode' => 'required|integer'
        ]);
        $user = $request->user();
        $pin = $request->pincode;

        if ($user->pincode == null) {
            return response()->json([
                "success" => false,
                "message" => "Not requested",

            ], 400);
        }

        if ($user->pincode_expire < Carbon::now()->timestamp) {
            return response()->json([
                "success" => false,
                "message" => "Pincode Expired",

            ], 400);
        }
        if ((int)$pin === (int)$user->pincode) {

            $user->update(["pincode" => null, "pincode_expire" => Carbon::now()->format('Uu') - 1000, "email_verified" => true]);

            return response()->json([
                "success" => true,
                "message" => "Email verified",

            ], 200);
        }

        return response()->json([
            "success" => false,
            "message" => "Invalid Pincode",

        ], 400);
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

    public function sendpin(Request $request)
    {
        $user = $request->user();
        if ($user->email_verified) {
            return response()->json([
                "success" => false,
                "message" => "You already verified",

            ], 400);
        }

        try {
            $pin = rand(100000, 999999);
            $pincode_expire = Carbon::now()->addMinutes(5)->timestamp;

            $user->update(['pincode' => $pin, "pincode_expire" => $pincode_expire]);
            $user->save();
           
            $username =  $user->firstname. " ".  $user->lastname;
          
            Mail::to($user->email)->send(new SendPin($pin,$username));
            return response()->json(["success" => true, "messasge" => "Pincode send"]);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500);
        }
    }

    public function update(UpdateRequest $request)
    {
        $user = $request->user();
        $validatedData = $request->validated();

        try {
            $updateData = [];
            if ($request->hasFile('profile_pic')) {

                $profile_picLogoPath = $user->profile_pic;
                if (File::exists($profile_picLogoPath)) {
                    File::delete($profile_picLogoPath);
                }
                $profile_pic = $request->file('profile_pic');
                $filenamep = time() . '_' . $profile_pic->getClientOriginalName();
                $profile_pic->move(public_path('uploads/users/profile_pic'), $filenamep);
                $updateData['profile_pic'] = 'uploads/users/profile_pic/'.$filenamep;
            }
            if($user->email){
                $updateData['email_verified'] = 0;
            }
            $user->update(array_merge($updateData, [
                "firstname" => $validatedData["firstname"] ?? $user->firstname,
                "lastname" => $validatedData["lastname"] ?? $user->lastname,
                "email" => $validatedData["email"] ?? $user->email,
                "age" => $validatedData["age"] ?? $user->age,
                "gender" => $validatedData["gender"] ?? $user->gender,
                'facebook_profile_link'=>$validatedData["facebook_profile_link"]??$user->facebook_profile_link,
                'linkedin_profile_link'=>$validatedData["linkedin_profile_link"]??$user->linkedin_profile_link,
                'github_profile_link'=>$validatedData["github_profile_link"]??$user->github_profile_link,
                'other_profile_link'=>$validatedData["other_profile_link"]??$user->other_profile_link,

                "about_me" => $validatedData["about_me"] ?? $user->about_me,

            ]));
            return response()->json([
                "success" => true,
                "message" => "User updated successfully",
                "user" => $user
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500);
        }
    }

    public function delete(Request $request)
    {
        try {

            $request->user()->delete();

            $user = $request->user();
            if($user->profile_pic){
            $profile_picLogoPath = public_path('uploads/users/profile_pic/' . $user->profile_pic);
            if (File::exists($profile_picLogoPath)) {
                File::delete($profile_picLogoPath);
            }}
            $user->delete();

            return response()->json([
                "success" => true,
                "message" => "User deleted"
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500);
        }
    }
    public function logout(Request $request) {
        try{
            $user = $request->user();
            $user->tokens()->delete();
            return response()->json(['sucess'=>true,'message' => 'Logged out'], 200);
        }
        catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 500); 
        }
    }
}
