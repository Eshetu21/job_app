<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Education extends Model
{
    use HasFactory;

    protected $fillable = [
        'job_seeker_id',
        'school_name',
        'field',
        'education_level',
        'edu_start_date',
        'edu_end_date',
        'description'
    ];

    public function jobseeker(){
        return $this->belongsTo(JobSeeker::class);
    }
}
