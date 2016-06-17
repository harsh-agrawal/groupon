# == Schema Information
#
# Table name: orders
#
#  id        :integer          not null, primary key
#  user_id   :integer          not null
#  deal_id   :integer          not null
#  quantity  :integer          default(1), not null
#  status    :integer          default(0)
#  placed_at :datetime
#  price     :integer          not null
#
# Indexes
#
#  index_orders_on_deal_id  (deal_id)
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_32b7e10d26  (deal_id => deals.id)
#  fk_rails_f868b47f6a  (user_id => users.id)
#

class Order < ActiveRecord::Base

  self.per_page = 10

  has_many :payment_transactions  , dependent: :destroy
  has_many :coupons, dependent: :restrict_with_error
  belongs_to :user
  belongs_to :deal

  enum status: [:pending, :paid, :processed]

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :user, presence: true
  validates :deal, presence: true
  validates :status, presence: true
  validates_with QuantityValidator, if: :qty_validation_required?
  validates_with LiveDealValidator, unless: :coupon_generated?

  scope :paid, -> { where( "status = ?", Order.statuses[:paid] ) }
  scope :pending, -> { where( "status = ?", Order.statuses[:pending] ) }
  scope :placed, -> { where("status = ? OR status = ?", Order.statuses[:paid], Order.statuses["processed"] ) }
  scope :by_deal, -> (deal_id) { where("deal_id = ?", deal_id ) }

  before_save :update_sold_quantity, if: :deal_bought
  before_save :set_order_placed_at, if: :deal_bought

  def qty_validation_required?
    ["pending", "paid"].include? status
  end

  def coupon_generated?
    if status_changed?
      status_was == "paid" && status == "processed"
    end

  end

  def deal_bought
    if status_changed?
      status_was == "pending" && status == "paid"
    end
  end

  def calculate_total_price
    quantity * price
  end

  def total_price_in_cents
    (calculate_total_price * 100).to_i
  end

  def mark_paid(transaction_details)
    transaction = payment_transactions.build(transaction_details)
    transaction.user = user
    self.status = "paid"
    save
  end

  private

  def set_order_placed_at
    self.placed_at = Time.current
  end

  def update_sold_quantity
    deal.increase_sold_qty_by(quantity)
  end

end
