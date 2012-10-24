class HomeController < ApplicationController

  def index
    redirect_to controller: 'companies', action: 'show', id: current_company.id
  end

end
