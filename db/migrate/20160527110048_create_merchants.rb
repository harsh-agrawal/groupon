class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.index :email, unique: true
      t.string :password_digest, null: false
      t.timestamps null: false
    end
  end
end
