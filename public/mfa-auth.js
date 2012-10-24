// MFA authentication module
// to be included in companies' page to request user for 2nd authentication
//
//
// how it works:
// 1. Create a form with 1 field to enter the token, 1 button to verify & 1 button to k
// 2. Customer click the button
// 3. It sends request to our server to send message to the user
//    and display a form for user to enter the token
// 4. User enters the token and submit
// 5. Authentication successful. Notify company that user is verified
//    5.1 Authentication fail. Ask user to reenter.
//    5.2 Failure 3 times => resend sms.
//
(function() {

  // TODO: figure out how client should make use of the validation result
  var validatedCallback = function(data) {
    console.log('validatedCallback', data);
    alert('Received validation token = ' + data.token);
  };

  var requestedCallback = function(data) {
    console.log('requestedCallback', data);
    if (data.status = 'OK') {
      alert('An OTP code has been sent to your phone. Please enter it to validate your access!');
    }
  };

  // TODO: need to extract user / company information to send with the request
  var submitOTP = function(evt) {
    var otp = $(otp_input).val();
    $.ajax({
      url: 'http://0.0.0.0:3000/validate.js',
      data: {'otp': otp},
      success: validatedCallback,
      dataType: 'jsonp'
    });
  };

  // TODO: need to extract user / company information to send with the request
  var requestOTP = function(evt) {
    var otp = $(otp_input).val();
    $.ajax({
      url: 'http://0.0.0.0:3000/requestOtp.js',
      success: requestedCallback,
      dataType: 'jsonp'
    });
  };

  var otp_input = $('<input>').addClass('mfa-input');
  var otp_submit = $('<button>').html('Submit').addClass('mfa-submit-btn');
  var otp_regen = $('<button>').html('Resend OTP Code').addClass('mfa-regenerate-btn');
  var otp_form = $('<div>').addClass('mfa-form');
  otp_form.append(otp_input).append(otp_submit).append(otp_regen);
  $(otp_submit).click(submitOTP);
  $(otp_regen).click(requestOTP);

  $('#otp-script').parent().append(otp_form);
  // initial request.
  requestOTP();
}).call(this);
