<?php

namespace App\Http\Controllers;

use App\Models\Job;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class JobController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function fetchjobs(Request $request)
    {
        try {
            
            $sortBy = $request->input('sortby', 'created_at');
            $sortOrder = $request->input('sortorder', 'desc'); 
    
            $fields = $request->input('fields', '*');
    
          
            $perPage = $request->input('per_page', 10);
    
            
            $jobs = Job::select(explode(',', $fields))
                        ->orderBy($sortBy, $sortOrder)
                        ->paginate($perPage);
                        $jobsArray = $jobs->toArray();

                       
                        unset($jobsArray['links']);
    
           
            return response()->json(["success" => true, "jobs" => $jobsArray], 200);
        } catch (Exception $e) {
            return response()->json(["success" => false, "message" => $e->getMessage()]);
        }
    }

    public function deletejob(Job $job,Request $request){
            $user = $request->user();
            

    }

    //
    
}
