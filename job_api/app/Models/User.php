<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;

use App\Notifications\verification;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements MustVerifyEmail
{
    use HasFactory, Notifiable, HasApiTokens;

    /* The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'firstname',
        'lastname',
        'email',
        'age',
        'gender',
        'address',
        'profile_pic',
        'role',
        'password',
        'email_verification_pincode',
        'facebook_profile_link',
        'other_profile_link',
        'linkedin_profile_link',
        'github_profile_link',
        'pincode_expire',
        "email_verified",
        "resetpin_verified",
        'manage_accounts',
        'add_admins',
        'manage_stats',
        'pincode',
        'can_delete_admin'
    ];

    /* The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'email_verification_pincode',
        'pincode_expire',
        'manage_accounts',
        'add_admins',
        'manage_stats',
        'manage_jobs',
        'can_delete_admin',
        'pincode',
        "resetpin_verified",

    ];

    /*
      Get the attributes that should be cast.
     
      @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function company()
    {
        return $this->hasOne(Company::class);
    }
    public function jobseeker()
    {
        return $this->hasOne(JobSeeker::class);
    }
    public function privateclient()
    {
        return $this->hasOne(PrivateClient::class);
    }
}
