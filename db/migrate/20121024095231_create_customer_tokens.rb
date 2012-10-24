class CreateCustomerTokens < ActiveRecord::Migration
  def change
    create_table :customer_tokens do |t|
      t.string :user_id
      t.string :token
      t.boolean :is_valid
      t.datetime :expired_at

      t.timestamps
    end
  end
end
