<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CanDeleteAdmin
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        {
            if(!$request->user() || $request->user()->role!="admin") {
                return response()->json(["success"=>false,"message"=>"you are not admin"],401);
            }
            if(!$request->user() || $request->user()->can_delete_admin==false) {
                return response()->json(["success"=>false,"message"=>"you dont have permission"],401);
            }
           
            return $next($request);
        }
        return $next($request);
    }
}
