class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.index :email, unique: true
      t.string :password_digest
      t.boolean :admin, default: false
      t.string :remember_token, default: nil
      t.string :verification_token, default: nil
      t.datetime :verification_token_expire_at, default: nil
      t.datetime :verified_at, default: nil
      t.string :forgot_password_token, default: nil
      t.datetime :forgot_password_expire_at, default: nil
      t.timestamps null: false
    end
  end
end
