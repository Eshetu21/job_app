<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class ForgetPasswordReset extends Mailable
{
    use Queueable, SerializesModels;
    public $pin;
    public $username;
    /**
     * Create a new message instance.
     */
    public function __construct($pin, $username)
    {
        $this->pin = $pin;
        $this->username = $username;
     
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Reset your password',
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
    
        return new Content(
           view: 'resetpassword',
           with: [
            'pin' => $this->pin,
            'username' => $this->username,
        ]
      
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [
          
        ];
    }
}