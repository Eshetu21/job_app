<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('firstname');
            $table->string('lastname');
            $table->enum('role',['user','admin'])->default('user');
            $table->string('email')->unique();
            $table->integer('age')->nullable();
            $table->integer('email_verification_pincode')->nullable();
            $table->bigInteger('pincode_expire')->nullable();
            $table->enum('gender', ['male', 'female'])->nullable();
            $table->string('address')->nullable();
            $table->boolean('email_verified')->default(false);
            $table->string('password');
            $table->string('facebook_profile_link')->nullable();
            $table->string('linkedin_profile_link')->nullable();
            $table->string('github_profile_link')->nullable();
            $table->string('other_profile_link')->nullable();
            $table->string('profile_pic')->nullable();
            $table->boolean('manage_accounts')->default(false);
            $table->boolean('add_admins')->default(false);
            $table->boolean('manage_stats')->default(false);
            $table->boolean('manage_jobs')->default(false);  
            $table->boolean('can_delete_admin')->default(false);  
            $table->rememberToken();
            
            $table->timestamps();
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
