<?php

namespace App\Http\Controllers;

use App\Models\Job;
use Exception;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;

class JobController extends Controller
{
    public function fetchjobs(Request $request)
    {
        try {
            $sortBy = $request->input('sortby', 'created_at');
            $sortOrder = $request->input('sortorder', 'desc');
            $fields = $request->input('fields', '*');
            $jobs = Job::select(explode(',', $fields))
                ->orderBy($sortBy, $sortOrder)->get();
            return response()->json(["success" => true, "jobs" => $jobs], 200);
        } catch (Exception $e) {
            return response()->json(["success" => false, "message" => $e->getMessage()]);
        }
    }
    public function fetchjob(Request $request, $id)
    {
        try {


            $job = Job::findorfail($id);

            return response()->json(["success" => true, "jobs" => $job], 200);
        } catch (ModelNotFoundException $m) {
            return response()->json(["success" => false, "message" => "Job not found"], 404);
        } catch (Exception $e) {
            return response()->json(["success" => false, "message" => $e->getMessage()]);
        }
    }
    public function deletejob(Request $request, $type, $id)
    {
        try {
            $job = Job::findOrFail($id);
            $user = $request->user();
            if ($type == "company") {
                $companyId = $user->company?->id;
                $jobOwnerId = $job->company_id;
                if ($jobOwnerId === $companyId) {
                    $job->delete();
                    return response()->json(["success" => true, "message" => "Job deleted successfully"], 200);
                } else {
                    return response()->json(["success" => false, "message" => "You can not delete this job"], 403);
                }
            } else if ($type == "privateclient") {
                $privateClientId = $user->privateclient?->id;
                $jobOwnerId = $job->private_client_id;
                if ($jobOwnerId === $privateClientId) {
                    $job->delete();
                    return response()->json(["success" => true, "message" => "Job deleted successfully"], 200);
                } else {
                    return response()->json(["success" => false, "message" => "You can not delete this job"], 403);
                }
            } else {
                return response()->json(["success" => false, "message" => "Page not found"], 400);
            }
        } catch (ModelNotFoundException $m) {
            return response()->json(["success" => false, "message" => "Job not found"], 404);
        }
    }
    public function editjob(Request $request, $type, $id)
    {
        try {
            $job = Job::findOrFail($id);
            $user = $request->user();
            if ($type == "company") {
                $companyId = $user->company?->id;
                $jobOwnerId = $job->company_id;
                if ($jobOwnerId === $companyId) {
                    $validatedData = $request->validate([
                        'title' => 'required|string',
                        'type' => 'required|string',
                        'sector' => 'required|string',
                        'city' => 'required|string',
                        'gender' => 'required|string',
                        'salary' => 'nullable|numeric',
                        'deadline' => 'required|string',
                        'description' => 'required|string',
                    ]);
                    $job->update($validatedData);
                    return response()->json(["success" => true, "message" => $job], 200);
                } else {
                    return response()->json(["success" => false, "message" => "You can not edit this job"], 403);
                }
            } else if ($type == "privateclient") {
                $privateClientId = $user->privateclient?->id;
                $jobOwnerId = $job->private_client_id;
                if ($jobOwnerId === $privateClientId) {
                    $validatedData = $request->validate([
                        'title' => 'required|string',
                        'type' => 'required|string',
                        'sector' => 'required|string',
                        'city' => 'required|string',
                        'gender' => 'required|string',
                        'salary' => 'nullable|numeric',
                        'deadline' => 'required|string',
                        'description' => 'required|string',
                    ]);
                    $job->update($validatedData);
                    return response()->json(["success" => true, "message" => $job], 200);
                } else {
                    return response()->json(["success" => false, "message" => "You can not edit this job"], 403);
                }
            } else {
                return response()->json(["success" => false, "message" => "Page not found"], 400);
            }
        } catch (ModelNotFoundException $m) {
            return response()->json(["success" => false, "message" => "Job not found"], 404);
        }
    }
}
