class CreateDealImages < ActiveRecord::Migration
  def change
    create_table :deal_images do |t|
      t.string :name, null: false
      t.references :deal, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
