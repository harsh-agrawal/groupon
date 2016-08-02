class AddNotifiedToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :notified, :boolean, default: false
  end
end
