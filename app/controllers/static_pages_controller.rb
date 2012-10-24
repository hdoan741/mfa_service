class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def validate
    validationResult = {
      :status => "OK",
      :token => "ABCDKWEIFJ"
    }
    respond_to do |format|
      format.js { render json: validationResult, callback: params[:callback] }
    end
  end

  def requestOtp
    requestResut = {
      :status => "OK"
    }
    respond_to do |format|
      format.js { render json: requestResut, callback: params[:callback] }
    end
  end
end
