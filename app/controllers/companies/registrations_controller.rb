class Companies::RegistrationsController < Devise::RegistrationsController

  before_filter :generate_extra_params, :only => [:create]

  def generate_extra_params
    puts params
    params[:company][:app_id] = '1'      # generate unique app id for each app
    params[:company][:secret_key] = '2'  # generate secret key for each app << Zhong Liang
    puts params
  end
end
