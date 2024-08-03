<?php

namespace App\Http\Controllers;


use App\Models\Company;
use Illuminate\Http\Request;

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
            'job_start_date' => 'required|date',
            'job_end_date' => 'required|date|after_or_equal:job_start_date',
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
}
