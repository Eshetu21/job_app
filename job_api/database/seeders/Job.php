<?php

namespace Database\Seeders;

use App\Models\Job as ModelsJob;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class Job extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
            ModelsJob::factory(80)->state([ 'company_id'=>1,'private_client_id'=>1])->create();
    }
}
