class Companies::RegistrationsController < Devise::RegistrationsController

  before_filter :generate_extra_params, :only => [:create]
  after_filter :send_sms, :only => [:create]

  def generate_extra_params
    puts params
    params[:company][:app_id] = '1'      # generate unique app id for each app
    params[:company][:secret_key] = '2'  # generate secret key for each app << Zhong Liang

    username = "39u39ur2@gmail.com"
    count = 30

    s = OTP::Secret_Gen.new(username)
    secret = s.generate_secret
    puts("[secret: #{secret}]")

    h = OTP::OTP_Gen.new(secret,count)
    puts("[otp0: #{h.generate_otp}]")

    (0..20).each{ |c|
      h.count = c
      puts("[otp#{c+1}: #{h.generate_otp}]")
    }

    puts params
  end

  def send_sms
    # sms = Hoi::SMS.new("CVcN6l8VRKOsdJ0s", "suetTN0vjkDxOksW")
    # sms.send( :msg => "Company Signed!", :dest => "+6592710879")
    # puts "Sms sent"
  end
end
