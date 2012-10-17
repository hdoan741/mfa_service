class CreateCompanyCustomers < ActiveRecord::Migration
  def change
    create_table :company_customers do |t|
      t.integer :customer_id
      t.integer :company_id
      t.integer :tries
      t.integer :success

      t.timestamps
    end
  end
end
