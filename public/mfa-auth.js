

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
  // create a form
  var createElement = function(type, attrs) {
    var el = document.createElement(type);
    for (attr_name in attrs) {
      el.setAttribute(attr_name, attrs[attr_name]);
    }
    return el;
  };

  var generate_form = function() {
    var otp_form = createElement('form', {
      'class': 'mfa-form'
    });
    var otp_input = createElement('input', {
      'class': 'mfa-input'
    });
    var otp_submit = createElement('button', {
      'class': 'mfa-submit-btn',
    });
    var otp_regen = createElement('button', {
      'class': 'mfa-regenerate-btn',
    });
    otp_form.appendChild(otp_input);
    otp_form.appendChild(otp_submit);
    otp_form.appendChild(otp_regen);
    return otp_form;
  };

  var otp_form = generate_form();
  var form_el = document.getElementById('otp-script');
  form_el.parentNode.appendChild(otp_form);
}).call(this);
