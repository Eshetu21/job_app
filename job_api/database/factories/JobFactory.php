<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Job>
 */
class JobFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {

        return [
       
       
        'job_title'=>fake()->jobTitle(),
        'job_location'=>fake()->address(),
        'job_salary'=>fake()->numberBetween(1000,50000),
        'job_start_date'=>fake()->date(),
        'job_end_date'=>fake()->date(),
        'job_description'=>fake()->text()
    
        ];
    }
}
