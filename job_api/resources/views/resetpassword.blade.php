
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset your password</title>
</head>
<body>
   <div style="width: 100%;">
   <pre style="font-size: 15px; font-family: 'Times New Roman', Times, serif; padding: 3px; box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.4);">
    Hi <b style="color: gray;">{{ $username }}</b>,

Your password reset code is: <b>{{ $pin }}</b>

Enter this code in {{config('constants.appname')}} app to reset password. This code is valid for <b>5</b> minutes. If you didn't request this, please ignore this email.

{{config('constants.appname')}} Team


</pre>
   </div>
         
         
</body>
</html>