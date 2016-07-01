# == Schema Information
#
# Table name: merchants
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_merchants_on_email  (email) UNIQUE
#

class Merchant < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :deals, dependent: :restrict_with_error
  has_many :orders, through: :deals
  has_many :coupons, through: :orders
  has_many :successful_deals, -> { successfully_expired },  class_name: "Deal"
  has_many :successful_orders, through: :successful_deals, class_name: "Order", source: :orders

  def order_sum(start_time, end_time)
    if start_time && end_time
      @orde_sum ||= successful_orders.by_time(start_time, end_time).sum(:price)
    else
      @order_sum ||= successful_orders.sum(:price)
    end
  end
end
