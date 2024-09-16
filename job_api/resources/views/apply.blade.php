<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New application submitted</title>
</head>
<body>
<div style="width: 100%;">
   <pre style="font-size: 13px; font-family: 'Times New Roman', Times, serif; padding: 3px; box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.4);">
        <h2 style="font-size: 14px;"> Dear <b>{{$companyname}}</b>,</h2>
         
         We are writing to inform you that a new application has been submitted for the position of <b>{{$jobtitle}}</b>. The candidate, <b>{{$username}}</b>, has provided all necessary documents for your review.
         
         Please log in to {{config('constants.appname')}} and proceed with the next steps.
         
         {{config('constants.appname')}} Team
         Best regards,
         </pre>
         
   </div>
         
</body>
</html>

