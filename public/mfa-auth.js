

// MFA authentication module
// to be included in companies' page to request user for 2nd authentication
//
//
// how it works:
// 1. Display a "Send SMS verification" button
// 2. Customer click the button
// 3. It sends request to our server to send message to the user
//    and display a form for user to enter the token
// 4. User enters the token and submit
// 5. Authentication successful. Notify company that user is verified
//    5.1 Authentication fail. Ask user to reenter.
//    5.2 Failure 3 times => resend sms.
//
(function() {
  alert('hello world!')
}).call(this);
