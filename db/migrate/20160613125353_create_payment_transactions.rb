class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.string :charge_id
      t.integer :amount
      t.string :currency
      t.string :stripe_customer_id
      t.string :stripe_token
      t.string :stripe_token_type
      t.string :description
      t.string :stripe_email
      t.references :user, index: true, foreign_key: true      
      t.references :order, index: true, foreign_key: true      
    end
  end
end
