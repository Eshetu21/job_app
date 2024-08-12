<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Http\Requests\StoreAdminRequest;
use App\Http\Requests\UpdateAdminRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Process;
use Illuminate\Support\Facades\Validator;


class AdminController extends Controller
{
    public function login(Request $request)
    {
        $validatedData =  Validator::make($request->all(), [
            'username' => 'required',
            'password' => 'required'
        ]);

        if ($validatedData->failed()) {
            response()->json(["success" => false, "message" => $validatedData->errors()], 400);
        }
        if ($validatedData->passes()) {

            $admin = Admin::where('username', $request->username)->first();
            if (!$admin || !Hash::check($request->password,$admin->password)) {
                return response()->json([
                    "success" => false,
                    "message" => "Invalid Credientials"
                ], 401);
            }

            $token = $admin->createToken("admin_token")->plainTextToken;
            return response()->json([
                "token" => $token
            ], 200);
        }
    }


    public function register(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'username' => 'required|unique:admins,username',
            'password' => 'required',
            'adminid' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                "success" => false,
                "message" => $validator->errors()
            ], 400);
        }


        if ($request->adminid != env('ADMIN_ID')) {
            return response()->json([
                "success" => false,
                "message" => "Invalid Credentials"
            ], 401);
        }

         $hashedP = Hash::make($request->password);

        $admin = Admin::create(['username'=>$request->username,'password'=>$hashedP]); 


        if (!$admin) {
            return response()->json([
                "success" => false,
                "message" => "Something went wrong"
            ], 500);
        }


        $token = $admin->createToken("admin_token")->plainTextToken;

        return response()->json([
            "success" => true,
            "token" => $token
        ], 200);
    }
}
