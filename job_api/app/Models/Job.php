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
        'job_title',
        'job_location',
        'job_salary',
        'job_start_date',
        'job_end_date',
        'job_description'
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
