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
            'exp_position_title'=>'required|string',
            'exp_company_name'=>'required|string',
            'exp_job_type'=>'required|string',
            'exp_start_date'=>'required|string',
            'exp_end_date'=>'required|string',
            'exp_description'=>'required|string'
        ];
    }
}
