<?php

namespace Database\Seeders;

use App\Models\Admin;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobSeeker;
use App\Models\PrivateClient;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        DB::table('users')->insert([
            'firstname' => fake()->name(),
            'lastname' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'password' => Hash::make('password'),
            'role' => 'admin',

            'manage_accounts' => true,
            'add_admins' => true,
            'manage_stats' => true,
            'manage_jobs' => true,
            'can_delete_admin' => true
        ]);
        // User::factory(10)->create();
        User::factory(10)->create();
        Company::factory(5)->create();
        PrivateClient::factory(5)->create();
        JobSeeker::factory(5)->create();
        Job::factory(7)->create();
       
    }
}
