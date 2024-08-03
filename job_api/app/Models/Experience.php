<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Experience extends Model
{
    use HasFactory;

    protected $fillable = [
        'job_seeker_id',
        'position_title',
        'exp_company_name',
        'exp_job_type',
        'exp_start_date',
        'exp_end_date',
        'exp_description'
    ];

    public function jobseeker()
    {
        return $this->belongsTo(JobSeeker::class);
    }
}
