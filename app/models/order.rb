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

  has_one :payment_transaction
  belongs_to :user
  belongs_to :deal

  enum status: [:pending, :paid, :processed]

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user, presence: true
  validates :deal, presence: true
  validates :status, presence: true

  scope :paid, -> { where( "status = ?", Order.statuses[:paid] ) }
  scope :pending, -> { where( "status = ?", Order.statuses[:pending] ) }
  scope :deal, -> (deal_id) { where("deal_id = ?", deal_id ) }

  #FIXME_AB: on save, linked to status
  validates_with QuantityValidator, if: :check_status

  after_save :update_sold_quantity, if: :deal_bought

  def check_status
    ["pending", "paid"].include? status
  end

  def deal_bought
    if changes && changes[:status]
      status_changed = changes[:status]
      status_changed[0] == "pending" && status_changed[1] == "paid"
    end
  end

  def calculate_total_price
    quantity * deal.price
  end

  private

  def update_sold_quantity
    updated_sold_quantity = deal.sold_quantity + quantity
    deal.update_attribute(:sold_quantity, updated_sold_quantity)
  end

end
