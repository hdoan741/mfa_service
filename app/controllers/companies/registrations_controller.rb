class Companies::RegistrationsController < Devise::RegistrationsController

  before_filter :generate_extra_params, :only => [:create]
  after_filter :send_sms, :only => [:create]

  def generate_extra_params
    puts params
    params[:company][:app_id] = '1'      # generate unique app id for each app
    params[:company][:secret_key] = '2'  # generate secret key for each app << Zhong Liang
    puts params
  end

  def send_sms
  	 sms = Hoi::SMS.new("CVcN6l8VRKOsdJ0s", "suetTN0vjkDxOksW")
     sms.send( :msg => "Company Signed!", :dest => "+6592710879" , :sender_name => "Easy MFA Service")
     puts "Sms sent"
  end
end
