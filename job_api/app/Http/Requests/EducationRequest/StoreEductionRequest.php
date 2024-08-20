<?php

namespace App\Http\Requests\EducationRequest;

use Illuminate\Foundation\Http\FormRequest;

class StoreEductionRequest extends FormRequest
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
            "school_name"=>"required|string",
            "field"=>"required|string",
            "education_level"=>"required|string",
            "edu_start_date"=>"required|string",
            "edu_end_date"=>"required|string",
            "description"=>"required|string"
        ];
    }
}
