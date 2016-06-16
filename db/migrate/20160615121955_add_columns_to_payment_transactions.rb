class AddColumnsToPaymentTransactions < ActiveRecord::Migration
  def change
    change_table(:payment_transactions, bulk: true) do |t|
      t.string :card_brand, null: false
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.integer :last_four_digits, null: false
    end
  end
end
