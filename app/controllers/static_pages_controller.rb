class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def validate
    # 1. get customer email
    uemail = params[:user_email]
    customer = Customer.find_by_email(uemail)
    # 2. get token
    token = params[:otp_token]
    # 3. check in the database if token is ok
    customerToken = CustomerToken.find_by_token_and_user_id(token, customer.id)

    if !customerToken
      validationResult = {
        :status => "ERROR",
        :reason => "Invalid token, please try again or request another token."
      }
    elsif customerToken.expired_at > Time.now
      validationResult = {
        :status => "ERROR",
        :reason => "Token expired."
      }
    elsif customerToken && customerToken.expired_at < Time.now
      validationResult = {
        :status => "OK",
      }
    end

    respond_to do |format|
      format.js { render json: validationResult, callback: params[:callback] }
    end
  end

  def requestOtp
    puts params
    uemail = params[:user_email]
    cid = params[:company_id]
    customer = Customer.find_by_email(uemail)
    company = Company.find_by_id(cid)
    ccexist = CompanyCustomer.find_by_company_id_and_customer_id(cid, customer.id)
    if !ccexist
      resp = {
        status: 'ERROR',
        reason: 'No such customer found.'
      }
    else
      # 1. generate the token
      #   => need customer email
      #   => need company id
      #   => might need to verify the company identity
      token = "asdf" # generate token for the customer

      # 2. store token in database, invalidate all tokens before that
      oldToken = CusomterToken.find_by_user_id_and_is_valid(
        user_id: customer.id,
        is_valid: true
      )
      oldToken.is_valid = false
      oldToken.save

      customerToken = CustomerToken.new({
        user_id: customer.id,
        token: token,
        expired_at: Time.now + 60,
        is_valid: true
      })

      if customerToken.save
        # 3. sms the token to customer
        msg = "Your access token for #{company.name} is #{token}"
        sms = Hoi::SMS.new("CVcN6l8VRKOsdJ0s", "suetTN0vjkDxOksW")
        sms.send(
          :msg => msg,
          :dest => customer.phone || "+6592710879",
          :sender_name => company.name
        )
        resp = {
          status: 'OK'
        }
      else
        resp = {
          status: 'ERROR',
          reason: 'Fail to generate token'
        }
      end
    end
    respond_to do |format|
      format.js do
        render(json: resp, callback: params[:callback])
      end
    end
  end
end
