class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :deal, index: true, foreign_key: true, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :status, default: 0
    end
  end
end
