class AddPriceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :price, :integer, null: false
  end
end
