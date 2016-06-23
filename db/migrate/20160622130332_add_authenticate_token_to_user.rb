class AddAuthenticateTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string, index: { unique: true }
  end
end
