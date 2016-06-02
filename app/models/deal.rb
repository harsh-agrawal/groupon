# == Schema Information
#
# Table name: deals
#
#  id                   :integer          not null, primary key
#  title                :string(255)      not null
#  description          :text(65535)
#  min_qty              :integer
#  max_qty              :integer
#  start_time           :datetime
#  expire_time          :datetime
#  price                :decimal(8, 2)
#  max_qty_per_customer :integer
#  instructions         :text(65535)
#  publishable          :boolean          default(FALSE)
#  category_id          :integer          not null
#  merchant_id          :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_deals_on_category_id  (category_id)
#  index_deals_on_merchant_id  (merchant_id)
#
# Foreign Keys
#
#  fk_rails_6b084cd147  (category_id => categories.id)
#  fk_rails_bed9e08b8f  (merchant_id => merchants.id)
#

class Deal < ActiveRecord::Base

  #FIXME_AB:  use with_options to group all publishable validations

  validates :title, presence: true
  validates :category, presence: true
  validates :merchant, presence: true
  #FIXME_AB:  also add min length(10 words) on description, when publish
  with_options if: "publishable?" do |deal|

    deal.validates :description, presence: true, length: {
      minimum: 10,
      tokenizer: lambda { |str| str.split(/\s+/)},
      too_short: "must have at least 10 words"
    }
    deal.validates :min_qty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    deal.validates :start_time, presence: true
    deal.validates :expire_time, presence: true
    deal.validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    deal.validates :instructions, presence: true
    #FIXME_AB: validates category and merchant
    deal.validates_associated :locations
    #FIXME_AB: don't need CategoryValidator and MerchantValidator. validates :category, presence: true will do
    deal.validates_with StartTimeValidator
    deal.validates_with ExpireTimeValidator
  end
  validates :max_qty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: ->(deal) { deal.min_qty } }, if: ("publishable? && min_qty?")
  validates :max_qty_per_customer, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: ->(deal) { deal.max_qty }}, if: ("publishable? && max_qty? ")
  belongs_to :category
  belongs_to :merchant
  has_many :locations, dependent: :destroy, validate: false
  accepts_nested_attributes_for :locations

  #FIXME_AB: before_update :check_if_deal_can_be_updated?
  before_update :check_if_deal_can_be_updated?, if: ("publishable?")


  def publish
    self.publishable = true
    save
  end

  def unpublish
    self.publishable = false
    save
  end

  private

  def check_if_deal_can_be_updated?
    if expire_time < Time.current
      errors[:base] << "Expired deal cannot be updated."
      false
    elsif Time.current.between?(start_time, expire_time)
      errors[:base] << "Live Deals cannot be updated."
      false
    end
  end

end
