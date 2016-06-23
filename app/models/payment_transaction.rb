# == Schema Information
#
# Table name: payment_transactions
#
#  id                 :integer          not null, primary key
#  charge_id          :string(255)
#  amount             :integer
#  currency           :string(255)
#  stripe_customer_id :string(255)
#  stripe_token       :string(255)
#  stripe_token_type  :string(255)
#  description        :string(255)
#  stripe_email       :string(255)
#  user_id            :integer
#  order_id           :integer
#  refund_id          :string(255)
#  card_brand         :string(255)
#  exp_month          :integer
#  exp_year           :integer
#  last_four_digits   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_payment_transactions_on_order_id  (order_id)
#  index_payment_transactions_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_1ccedddf37  (order_id => orders.id)
#  fk_rails_5baf18894b  (user_id => users.id)
#

class PaymentTransaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :order

  def total_price_in_dollars
    (amount / 100).to_i
  end
end
