class CompanyCustomer < ActiveRecord::Base
  attr_accessible :company_id, :customer_id, :success, :tries

  belongs_to :company
  belongs_to :customer
end
