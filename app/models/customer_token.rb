class CustomerToken < ActiveRecord::Base
  attr_accessible :expired_at, :is_valid, :token, :user_id
end
