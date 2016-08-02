class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.text :endpoint
      t.string :auth
      t.string :payload
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
