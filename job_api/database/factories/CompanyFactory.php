<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Company>
 */
class CompanyFactory extends Factory
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
            'company_name'=> fake()->company,
            'company_logo'=>fake()->text(20),
            'company_phone'=>fake()->phoneNumber(),
            'company_address'=>fake()->address(),
            'company_description'=>fake()->text(50)
        ];
    }
}
