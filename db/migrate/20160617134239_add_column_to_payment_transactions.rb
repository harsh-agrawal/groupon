class AddColumnToPaymentTransactions < ActiveRecord::Migration
  def change
    change_table(:payment_transactions, bulk: true) do |t|
      t.string :card_brand
      t.integer :exp_month
      t.integer :exp_year
      t.integer :last_four_digits
      t.timestamps null: false
    end
  end
end
