class CreateCustomerUpdateTokens < ActiveRecord::Migration
  def change
    create_table :customer_update_tokens do |t|
      t.integer :customer_id
      t.string :token
      t.token_type_id :type
      t.datetime :expiry_at

      t.timestamps
    end
  end
end
