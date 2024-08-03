<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Language extends Model
{
    use HasFactory;

    protected $fillable = [
        'job_seeker_id',
        'language',
        'proficiency_level'
    ];

    public function jobseeker()
    {
        return $this->belongsTo(JobSeeker::class);
    }
}
