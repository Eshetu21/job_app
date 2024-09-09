<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Jobseeker>
 */
class JobseekerFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        static $num = 1;
        return [
            'user_id'=>$num++,

            'category'=>fake()->text(20),
            'phone_number'=>fake()->phoneNumber(),
            'sub_category'=>fake()->text(20),
            'about_me'=>fake()->text(50)
        ];
    }
}
