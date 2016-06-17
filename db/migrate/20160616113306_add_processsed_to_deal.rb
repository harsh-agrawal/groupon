class AddProcesssedToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :processed, :boolean, default: false
  end
end
