class AddRefundToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :refund_id, :string
  end
end
