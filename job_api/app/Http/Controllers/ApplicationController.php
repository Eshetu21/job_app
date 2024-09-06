<?php

namespace App\Http\Controllers;

use App\Models\Application;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

class ApplicationController extends Controller
{
    public function fetchapps()
    {

        try {
            $apps = Application::all();
            if ($apps->count() == 0) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found",
                ], 404);
            }
            return response()->json([
                "success" => true,
                "applications" => $apps,
            ], 400);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
            ], 400);
        }
    }
    public function fetchapp($id)
    {

        try {
            $apps = Application::findorfail($id);
            if ($apps) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found",
                ], 404);
            }
            return response()->json([
                "success" => true,
                "application" => $apps,
            ], 400);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
            ], 400);
        }
    }
    public function deleteapp($id)
    {

        try {
            $app = Application::findorfail($id);
            if ($app) {
                return response()->json([
                    "success" => false,
                    "message" => "No application found",
                ], 404);
            }
            File::delete(public_path('uploads/application/cv/' + $app->cv));
            File::delete(public_path('uploads/application/cv/' + $app->cv));
            $app->delete();
            return response()->json([
                "success" => true,
                "message" => "Application deleted",
            ], 204);
        } catch (Exception $e) {
            return response()->json([
                "success" => false,
                "message" => $e->getMessage(),
            ], 400);
        }
    }
}
