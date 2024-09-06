<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\PrivateClient>
 */
class PrivateClientFactory extends Factory
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
            'profile_pic'=>fake()->text(20),
       
        ];
    }
}
