class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :secret_key
      t.string :app_id

      t.timestamps
    end
  end
end
