<?php

namespace App\Http\Controllers;

use App\Models\City;
use App\Http\Requests\StoreCityRequest;
use App\Http\Requests\UpdateCityRequest;
use Exception;

class CityController extends Controller
{
   public function getcities(){

   try{
    $cities = City::all();
    return response()->json([
        "success"=>true,
        "cities"=>$cities

    ],200);
   }catch(Exception $e){
    return response()->json([
        "success"=>false,
        "message"=>$e->getMessage()

    ],400);
   }
   }
}
