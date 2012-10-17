class Customer < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :verified

  has_many :companycustomers
  has_many :companies, through: :companycustomers
end
