<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Skill extends Model
{
    use HasFactory;

    protected $fillable = [
        'job_seeker_id',
        'skill'
    ];

    public function jobseeker()
    {
        return $this->belongsTo(JobSeeker::class);
    }
}
