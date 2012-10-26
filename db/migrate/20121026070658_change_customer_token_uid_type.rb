class ChangeCustomerTokenUidType < ActiveRecord::Migration
  def change
    change_column :customer_tokens, :user_id, :integer
  end
end
