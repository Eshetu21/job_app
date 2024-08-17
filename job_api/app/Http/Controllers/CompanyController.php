<?php

namespace App\Http\Controllers;


use App\Models\Company;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CompanyController extends Controller
{
    public function createcompany(Request $request)
    {
        $user = $request->user();
        if ($user->Company) {
            return response()->json([
                "message" => "Company already exists"
            ], 400);
        }
        $validatedData = $request->validate([
            "company_name" => "required|string|unique:companies",
            "company_logo" => "nullable|string",
            "company_phone" => "required|string",
            "company_address" => "required|string",
            "company_description" => "required|string"
        ]);
        $validatedData["user_id"] = $user->id;
        $company = Company::create($validatedData);
        $user->company->load('user');
        return response()->json([
            'message' => 'Company profile created successfully.',
            'creater' => $user->company
        ], 201);
    }

    public function companycreatejob(Request $request)
    {
        $user = $request->user();
        if (!$user->company) {
            return response()->json([
                "message" => "company not registerd"
            ], 400);
        }
        $validatedData = $request->validate([
            'job_title' => 'required|string|max:255',
            'job_location' => 'required|string|max:255',
            'job_salary' => 'nullable|numeric',

            'deadline' => 'required|date',
            'job_description' => 'required|string',
        ]);
        $validatedData['company_id'] = $user->company->id;
        $job = $user->company->jobs()->create(
            $validatedData
        );
        $user->company->load('user');
        return response()->json([
            "message" => "job created sucessfully",
            "job" => $job,
            "creater" => $user->company
        ], 201);
    }

    public function update(Request $request)
    {
        $user = $request->user();
        if (!$user->company) {
            return response()->json([
                "success" => false,
                "message" => "company not registered"
            ], 400);
        }
    
        try {
            $ValidatedData = Validator::make($request->all(), [
                "company_name" => "nullable|string|unique:companies",
                "company_logo" => "nullable|string",
                "company_phone" => "nullable|string",
                "company_address" => "nullable|string",
                "company_description" => "nullable|string"
            ]);
    
            $validatedDataArray = $ValidatedData->validated();
    
          $user->company->update([
                "company_name" => isset($validatedDataArray["company_name"]) ? $validatedDataArray["company_name"] : $user->company->company_name,
                "company_logo" => isset($validatedDataArray["company_logo"]) ? $validatedDataArray["company_logo"] : $user->company->company_logo,
                "company_phone" => isset($validatedDataArray["company_phone"]) ? $validatedDataArray["company_phone"] : $user->company->company_phone,
                "company_address" => isset($validatedDataArray["company_address"]) ? $validatedDataArray["company_address"] : $user->company->company_address,
                "company_description" => isset($validatedDataArray["company_description"]) ? $validatedDataArray["company_description"] : $user->company->company_description
            ]);
    
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
            ], 400);
        }
    
        return response()->json([
            "message" => "Data updated successfully",
            "updatedcompany" => $user->company
        ], 200);
    }
    

    public function delete(Request $request)
    {

        $user =   $request->user();
        if(!$user->company) {
            return response()->json([
                "success"=> false,
                "message" => "company not registerd"
            ], 400);
        }

        try {
            $user->company->delete();
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),

            ], 400);
        }
        return response()->json([
            "success" => true,
            "message" => "Company Deleted successfully",

        ], 200);
    }
}
