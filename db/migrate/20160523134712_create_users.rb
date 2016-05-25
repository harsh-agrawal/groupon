class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.index :email, unique: true
      t.string :password_digest, null: false
      t.boolean :admin, default: false
      t.string :remember_token, default: nil, index: true
      t.string :verification_token, default: nil, index: true
      t.datetime :verification_token_expire_at, default: nil
      t.datetime :verified_at, default: nil
      t.string :forgot_password_token, default: nil, index: true
      t.datetime :forgot_password_expire_at, default: nil
      t.timestamps null: false
      #FIXME_AB: missing indexes and null constraints
    end
  end
end
