<?php

namespace App\Http\Requests\JobRequest;

use Illuminate\Foundation\Http\FormRequest;

class StoreJobRequest extends FormRequest
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
            "job_title"=>"required|string",
            "job_location"=>"required|string",
            "job_salary"=>"required|string", 
            "deadline"=>"required|date",
            "job_description"=>"required|text"
        ];
    }
}
