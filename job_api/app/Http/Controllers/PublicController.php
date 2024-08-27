<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\JobSeeker;
use App\Models\Privateclient;
use App\Models\User;
use Illuminate\Http\Request;

class PublicController extends Controller
{
    public function getPrivateclient($privateclient_id){
     
        
            $privateclient = Privateclient::findorfail($privateclient_id);
                if (!$privateclient) {
                    return response()->json([
                        "success"=>false,
                        "message" => "privateclient doesn't exists"
                    ], 400);
                }
                return response()->json([
                    "success"=>true,
                    "privateclient"=>$privateclient
                ],200);
    }
    public function getCompany($company_id){
     
        
        $company = Company::findorfail($company_id);
            if (!$company) {
                return response()->json([
                    "success"=>false,
                    "message" => "company doesn't exists"
                ], 400);
            }
            return response()->json([
                "success"=>true,
                "company"=>$company
            ],200);
}
public function getJobseeker($jobseeker_id){
     
        
    $jobseeker = JobSeeker::findorfail($jobseeker_id);
        if (!$jobseeker) {
            return response()->json([
                "success"=>false,
                "message" => "jobseeker doesn't exists"
            ], 400);
        }
        return response()->json([
            "success"=>true,
            "jobseeker"=>$jobseeker
        ],200);
}
public function getUser($user_id){
     
        
    $user = User::findorfail($user_id);
        if (!$user) {
            return response()->json([
                "success"=>false,
                "message" => "user doesn't exists"
            ], 400);
        }
        return response()->json([
            "success"=>true,
            "user"=>$user
        ],200);
}
}
