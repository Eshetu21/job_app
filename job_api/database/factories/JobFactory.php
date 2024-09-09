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
        static $k=1;
        $k++;
        if($k>=5){
            $k = 1;
        }
        return [
       
       
        'title'=>fake()->jobTitle(),
        'city'=>fake()->address(),
        'salary'=>fake()->numberBetween(1000,50000),
        'deadline'=>fake()->date(),
        'description'=>fake()->text(),
        'sector'=>fake()->jobTitle(),
        'gender'=>"male",
        'type'=>"type",
        'company_id'=>$k%2==0? $k : null,
        'private_client_id'=>$k%2!=0? $k : null,
    
        ];
    }
}
