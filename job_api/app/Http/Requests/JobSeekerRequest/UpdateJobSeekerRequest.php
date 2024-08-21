<?php

namespace App\Http\Requests\JobSeekerRequest;

use Illuminate\Foundation\Http\FormRequest;

class UpdateJobSeekerRequest extends FormRequest
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
            'category' => 'required|string',
            'sub_category' => 'required|string',
            "profile_pic" => "nullable|mimes:png,jpg,jpeg|max:2048",
            "cv" => "nullable|mimes:pdf,doc|max:2048",
            'phone_number' => 'nullable|string',
            'about_me' => 'nullable|string'
        ];
    }
}
