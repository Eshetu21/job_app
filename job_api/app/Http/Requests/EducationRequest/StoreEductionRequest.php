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
            "school_name"=>"nullable|string",
            "field"=>"nullable|string",
            "education_level"=>"nullable|string",
            "edu_start_date"=>"nullable|date",
            "edu_end_date"=>"nullable|date",
            "description"=>"nullable|string"
        ];
    }
}
