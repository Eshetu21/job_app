<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Auth\Admin as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class Admin extends Model 
{
    use HasFactory, HasApiTokens;

    
    protected $fillable = [
        "username",
        "password"
    ];

    protected $hidden = [
        'password'
    ];
}
