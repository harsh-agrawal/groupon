class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title, null: false
      t.text :description
      t.integer :min_qty
      t.integer :max_qty
      t.datetime :start_time
      t.datetime :expire_time
      t.decimal :price, precision: 8, scale: 2
      t.integer :max_qty_per_customer
      t.text :instructions
      t.boolean :publishable, default: false
      t.references :category, index: true, foreign_key: true, null: false
      t.references :merchant, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
