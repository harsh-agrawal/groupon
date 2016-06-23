json.id order.id
json.deal order.deal.title
json.quantity order.quantity
json.status order.status
json.amount order.calculate_total_price
order_transaction = order.payment_transactions.order(created_at: :asc).first
refund_transaction = order.payment_transactions.order(created_at: :asc).second 
if order_transaction
  json.order_transactions do
    json.amount order_transaction.total_price_in_dollars
    json.currency order_transaction.currency
    json.card_brand order_transaction.card_brand
    json.card_exp_month order_transaction.exp_month
    json.card_exp_year order_transaction.exp_year
    json.last_four_digits order_transaction.last_four_digits
    json.order_placed_at order_transaction.created_at.to_s(:detailed)
  end
end
if refund_transaction
  json.refund_transactions do
    json.amount refund_transaction.total_price_in_dollars
    json.currency refund_transaction.currency
    json.refunded_at refund_transaction.created_at.to_s(:detailed)
  end
end


