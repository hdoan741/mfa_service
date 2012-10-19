class CreateTokenTypes < ActiveRecord::Migration
  def change
    create_table :token_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
