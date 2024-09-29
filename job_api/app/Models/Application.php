<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Application extends Model
{
    use HasFactory;

    protected $fillable = [
        'job_id',
        'jobseeker_id',
        'status',
        'statement',
        'cover_letter',
        'cv'
    ];

    public function job(){
        return $this->belongsTo(Job::class);
    }
    public function jobseeker(){
        return $this->belongsTo(User::class);
    }
    
}
