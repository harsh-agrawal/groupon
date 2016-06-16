class AddColumnToDeals < ActiveRecord::Migration
  def change
    add_column(:deals, :sold_quantity, :integer, default: 0)
  end
end
