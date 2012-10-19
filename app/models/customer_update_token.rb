class CustomerUpdateToken < ActiveRecord::Base
  attr_accessible :customer_id, :expiry_at, :token, :type
end
