<?php

namespace App\Http\Requests\JobSeekerRequest;

use Illuminate\Foundation\Http\FormRequest;

class StoreJobSeekerRequest extends FormRequest
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
            "category" => "nullable|string",
            "sub_category" => "nullable|string",
            "profile_pic" => "nullable|string",
            "cv" => "nullable|file|mimes:pdf,doc,docx,txt|max:2048",
            "phone_number" => "nullable|string",
            "about_me" => "nullable|string"
        ];
    }
}
