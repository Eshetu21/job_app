<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Job extends Model
{
    use HasFactory;

    protected $fillable = [
        'private_client_id',
        'company_id',
        'title' ,
        'site' ,
        'type' ,
        'sector' ,
        'city' ,
        'field',
        'gender' ,
        'location' ,
        'salary' ,
        'deadline',
        'description'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function privateclient()
    {
        return $this->belongsTo(PrivateClient::class);
    }

    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    public function applications()
    {
        return $this->hasMany(Application::class);
    }
}
