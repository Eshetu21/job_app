<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class RejectedMail extends Mailable
{
    use Queueable, SerializesModels;
    public $jobtitle;
    public $companyname;
    public $username;
    /**
     * Create a new message instance.
     */
    public function __construct($username,$companyname,$jobtitle)
    {
        $this->jobtitle = $jobtitle;
        $this->companyname = $companyname;
        $this->username = $username;

    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
        
            subject: "You're Rejected!",
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'jobrejected',
               );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
