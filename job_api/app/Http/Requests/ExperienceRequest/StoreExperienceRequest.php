<?php

namespace App\Http\Requests\ExperienceRequest;

use Illuminate\Foundation\Http\FormRequest;

class StoreExperienceRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'position_title'=>'nullable|string',
            'exp_company_name'=>'nullable|string',
            'exp_job_type'=>'nullable|string',
            'exp_start_date'=>'nullable|string',
            'exp_end_date'=>'nullable|string',
            'exp_description'=>'nullable|string'
        ];
    }
}
