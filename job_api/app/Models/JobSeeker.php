<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JobSeeker extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category',
        'sub_category',
        'phone_number',
        'about_me'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function educations()
    {
        return $this->hasMany(Education::class);
    }
    public function experiences()
    {
        return $this->hasMany(Experience::class);
    }
    public function languages()
    {
        return $this->hasMany(Language::class);
    }
    public function skills()
    {
        return $this->hasMany(Skill::class);
    }
    public function applications()
    {
        return $this->hasMany(Application::class);
    }
}
