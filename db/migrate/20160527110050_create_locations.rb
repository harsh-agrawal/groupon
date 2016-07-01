class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.references :deal, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
