<?php

namespace App\Http\Requests\UserRequest;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
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
            'firstname' => 'nullable|string',
            'lastname' => 'nullable|string',
            'email' => 'nullable|email|unique:users,email,' . $this->user()->id,
            'age' => 'nullable|integer',
            'gender' => 'nullable|string',
            'about_me' => 'nullable|string',
            'profile_pic'=> 'mimes:png,jpg,jpeg|max:2046',
           'address'=>'string',
        ];
    }
}
