class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.references :order, index: true, foreign_key: true
      t.string :code
      t.datetime :redeemed_at
      t.timestamps null: false
    end
  end
end
