# == Schema Information
#
# Table name: orders
#
#  id       :integer          not null, primary key
#  user_id  :integer          not null
#  deal_id  :integer          not null
#  quantity :integer          default(1), not null
#  status   :integer          default(0)
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
  has_one :payment_transaction, dependent: :destroy
  belongs_to :user
  belongs_to :deal

  enum status: [:pending, :paid, :processed]

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user, presence: true
  validates :deal, presence: true
  validates :status, presence: true
  validates_with QuantityValidator, if: :qty_validation_required?
  validates_with LiveDealValidator

  scope :paid, -> { where( "status = ?", Order.statuses[:paid] ) }
  scope :pending, -> { where( "status = ?", Order.statuses[:pending] ) }
  scope :not_pending, -> { where.not( "status = ?", Order.statuses[:pending] )}
  scope :deal, -> (deal_id) { where("deal_id = ?", deal_id ) }

  before_save :update_sold_quantity, if: :deal_bought
  before_save :set_order_placed_at, if: :deal_bought

  #FIXME_AB: add a validation that order can not be placed for past deal
  #FIXME_AB: add placed_at for order callback

  def qty_validation_required?
    ["pending", "paid"].include? status
  end

  def deal_bought
    if status_changed?
      status_was == "pending" && status == "paid"
    end
  end

  def calculate_total_price
    quantity * deal.price
  end

  private

  def set_order_placed_at
    self.placed_at = Time.current
  end

  def update_sold_quantity
    #FIXME_AB: deal.increase_sold_qty_by(quantity)
    # def increase_sold_qty_by(qty)
    #   sold_quantity+=qty
    #   save(false)
    # end
    deal.increase_sold_qty_by(quantity)
    # updated_sold_quantity = deal.sold_quantity + quantity
    # deal.update_attribute(:sold_quantity, updated_sold_quantity)
  end

end
