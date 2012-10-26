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
    if (data.status = 'OK') {
      alert('Received validation token = ' + data.token);
      var params = {
        validation_token: data.token,
        user_email: user_email
      };
      window.location.replace(forward_url + '?' + $.param(params));
    } else {
      alert('Error ' + data.reason);
      if (data.error_code == 2) {
        requestOTP();
      }
    }
  };

  var requestedCallback = function(data) {
    console.log('requestedCallback', data);
    if (data.status = 'OK') {
      alert('An OTP code has been sent to your phone. Please enter it to validate your access!');
    } else {
      alert('Error ' + data.reason);
    }
  };

  // TODO: need to extract user / company information to send with the request
  var submitOTP = function(evt) {
    var otp_token = $(otp_input).val();
    var data = {
      'otp_token': otp_token,
      'user_email': user_email,
      'company_id': company_id
    };
    $.ajax({
      url: 'https://mfa-service.herokuapp.com/validate.js',
      data: data,
      success: validatedCallback,
      dataType: 'jsonp'
    });
  };

  // TODO: need to extract user / company information to send with the request
  var requestOTP = function(evt) {
    var otp = $(otp_input).val();
    var data = {
      'user_email': user_email,
      'company_id': company_id
    };
    $.ajax({
      url: 'https://mfa-service.herokuapp.com/requestOtp.js',
      data: data,
      success: requestedCallback,
      dataType: 'jsonp'
    });
  };

  var otp_input = $('<input>').addClass('mfa-input');
  var otp_submit = $('<button>').html('Submit').addClass('mfa-submit-btn');
  var otp_regen = $('<button>').html('Resend OTP Code').addClass('mfa-regenerate-btn');
  var otp_form = $('<div>').addClass('mfa-form');

  var company_id = $('#otp-script').attr('data-company');
  var user_email = $('#otp-script').attr('data-user');
  var forward_url = $('#otp-script').attr('data-forward-url');
  console.log(company_id, user_email);

  otp_form.append(otp_input).append(otp_submit).append(otp_regen);
  $(otp_submit).click(submitOTP);
  $(otp_regen).click(requestOTP);

  $('#otp-script').parent().append(otp_form);

  // initial request.
  requestOTP();
}).call(this);
