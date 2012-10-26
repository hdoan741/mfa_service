class StaticPagesController < ApplicationController
  require "digest"
  def home
  end

  def help
  end

  def about
  end
  
  def changePasswordPage
  end

  def changePassword 
    puts "YAHOO!!"
    puts params
    @email = params[:email]
    @customer = Customer.find_by_email(@email)
    if @customer.nil?
      # do nothing
    else
      @secret =  Digest::MD5.hexdigest(@customer.email)
      UserMailer.password_link_email(@customer, @secret).deliver
      puts "[UserMailer] Email has been sent/ queued for sending"
    end
  end
  
  def validate
    # 1. get customer email
    puts params
    uemail = params[:user_email]
    begin
      customer = Customer.find_by_email(uemail)
      # 2. get token
      token = params[:otp_token]
      # 3. check in the database if token is ok
      puts customer.to_json
      customerToken = CustomerToken.find_by_token_and_user_id(token, customer.id)
      puts customerToken.to_json
      puts CustomerToken.all.to_json

      if !customerToken
        validationResult = {
          :validation_status => "ERROR",
          :error_code => 1,
          :reason => "Invalid token, please try again or request another token."
        }
      elsif customerToken.expired_at < Time.now
        validationResult = {
          :validation_status => "ERROR",
          :error_code => 2,
          :reason => "Token expired. Please request another token."
        }
      else
        # 4. generate a validation token. the company must use its secret_key & our library to verify
        # this token
        puts 'asdfasdf asdf asdf asdf'
        confirmation_token = 'dfsdfsdf'
        validationResult = {
          :validation_status => "OK",
          :token => confirmation_token
        }
      end
    rescue Exception
      validationResult = {
        :validation_status => "ERROR",
        :reason => "Something went wrong."
      }
    end

    validationResult = {
      :validation_status => "OK",
      :token => confirmation_token
    }

    puts validationResult

    respond_to do |format|
      format.js { render json: validationResult, callback: params[:callback] }
    end
  end

  def getOtp(company)
    hotp = OTP::OTP_Gen.new(company.secret_key || 'asdf', Time.now.to_i)  # should use counter based
    key = hotp.generate_otp
    puts key, hotp
    return hotp.generate_otp()
  end

  def requestOtp
    begin
      puts params
      uemail = params[:user_email]
      cid = params[:company_id]
      customer = Customer.find_by_email(uemail)
      company = Company.find_by_id(cid)
      # ccexist = CompanyCustomer.find_by_company_id_and_customer_id(cid, customer.id)
      # if !ccexist
      #  raise Exception, 'No customer - company relation exists.'
      # end

      # 1. generate the token
      #   => need customer email
      #   => need company id
      #   => might need to verify the company identity
      token = getOtp(company)  # generate token for the customer
      puts 'company: ', company, 'token: ', token

      # 2. store token in database, invalidate all tokens before that
=begin
      oldToken = CustomerToken.find_by_user_id_and_is_valid(customer.id, true)
      puts oldToken
      if oldToken
        oldToken.is_valid = false
        oldToken.save
      end
=end

      customerToken = CustomerToken.new({
        user_id: customer.id,
        token: token,
        expired_at: Time.now + 60 * 5,
        is_valid: true
      })

      if customerToken.save
        # 3. sms the token to customer
        # msg = "Your access token for #{company.name} is #{token}"
        # sms = Hoi::SMS.new("CVcN6l8VRKOsdJ0s", "suetTN0vjkDxOksW")
        # sms.send(
        #  :msg => msg,
        #  :dest => customer.phone || "+6592710879"
        #  :sender_name => company.name
        # )
        resp = {
          request_status: 'OK'
        }
      else
        resp = {
          request_status: 'ERROR',
          reason: 'Fail to generate token'
        }
      end
    rescue Exception => exc
      logger.error("Message for the log file #{exc.backtrace.join("\n")}")
      resp = {
        request_status: 'ERROR',
        reason: 'No customer or companies exists.'
      }
    end

    respond_to do |format|
      format.js do
        render(json: resp, callback: params[:callback])
      end
    end
  end
end
